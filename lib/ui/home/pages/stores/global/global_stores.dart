import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:embajadores/data/controllers/themenotifier.dart';
import 'package:embajadores/data/models/global_stores.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:embajadores/ui/home/pages/stores/store_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:darq/darq.dart';
import 'filter_stores.dart';
import 'package:intl/intl.dart';

class GlobalStatusStores extends StatefulWidget {
  const GlobalStatusStores({Key? key, required this.filter}) : super(key: key);
  final String? filter;

  @override
  _GlobalStatusStoresState createState() => _GlobalStatusStoresState();
}

class Sizes {
  Sizes(this.crossAxisCount, this.crossAxisSpacing, this.mainAxisSpacing,
      this.iconSize, this.fontSize, this.minFontSize, this.maxFontSize);
  int? crossAxisCount;
  double? crossAxisSpacing;
  double? mainAxisSpacing;
  double? iconSize;
  double? fontSize;
  double? minFontSize;
  double? maxFontSize;
}

class _GlobalStatusStoresState extends State<GlobalStatusStores> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final CustomColors _colors = CustomColors();
  GlobalKey previewContainer = GlobalKey();
  APIService apiService = APIService();
  int originalSize = 800;
  final prefs = UserPreferences();
  List<StoreData> storeData = [];
  var _openedStore = 0;
  var _closedStore = 0;
  var _massive = 0;
  var _incidents = 0;
  var _totalIncidents = 0;
  var _visible = false;
  var _visibleItem = true;
  var _filter = '';
  var _crossAxisCount = 6;
  final _crossAxisSpacing = 2.0;
  final _mainAxisSpacing = 2.0;
  var _fontSize = 12.0;
  var _minFontSize = 2.0;
  var _maxFontSize = 8.0;
  var _iconSize = 20.0;
  List<Sizes> sizes = [];
  Image? _image;
  Future<List<StoreData>> getAllStores(String filter) async {
    final counter = Provider.of<CounterProvider>(context, listen: false);
    var data = apiService.getAllStoresData(filter);
    await data.then((value) {
      prefs.ownerCount = value.length;
      storeData = value;
      _openedStore = storeData.count((e) => e.estado == 1);
      _closedStore = storeData.count((e) => e.estado == 0);
      _massive = storeData.count((e) => e.incidentes!.masivo == true);
      _incidents = storeData.count((e) => e.incidentes!.serviciosCaidos! > 0);
      _totalIncidents = storeData.sum((e) => e.incidentes!.serviciosCaidos!);
      counter.onChange(value.length);
    });
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sizes.add(Sizes(3, 2.0, 2.0, 40, 12, 4, 12));
    sizes.add(Sizes(4, 2.0, 2.0, 30, 12, 4, 10));
    sizes.add(Sizes(10, 2.0, 2.0, 20, 12, 2, 8));
    sizes.add(Sizes(6, 2.0, 2.0, 20, 12, 2, 8));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<StoreData>>(
          future: getAllStores(_filter),
          builder:
              (BuildContext context, AsyncSnapshot<List<StoreData>> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                  height: 500,
                  child: Center(child: CircularProgressIndicator()));
            } else {
              return SingleChildScrollView(
                child: Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    color: _colors.contextColor(context),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: GridView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _crossAxisCount,
                              crossAxisSpacing: _crossAxisSpacing,
                              mainAxisSpacing: _mainAxisSpacing,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return _assignedStoresCard(snapshot.data!, index);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Table(
                            defaultColumnWidth: const FixedColumnWidth(120.0),
                            border: TableBorder.all(
                                color: _colors.borderColor(context),
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              _tableRow('Tiendas', _colors.textColor(context),
                                  'Cantidad', 14),
                              _tableRow('Abiertas', Colors.green,
                                  _openedStore.toString(), 10),
                              _tableRow('Cerradas', Colors.blueGrey,
                                  _closedStore.toString(), 10),
                              _tableRow('Con masivo', Colors.redAccent,
                                  _massive.toString(), 10),
                              _tableRow('Afectadas', Colors.orangeAccent,
                                  _incidents.toString(), 10),
                              _tableRow(
                                  'Incidentes',
                                  _colors.textColor(context),
                                  _totalIncidents.toString(),
                                  10),
                              _tableRow(
                                  'Fecha',
                                  _colors.textColor(context),
                                  DateFormat('dd MMM yyyy - hh:mm a')
                                      .format(DateTime.now()),
                                  10)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDialFabWidget(
        secondaryIconsList: const [
          Icons.grid_3x3,
          Icons.grid_4x4,
          Icons.grid_on,
          Icons.grid_off,
          Icons.cleaning_services_rounded,
          Icons.filter_list_alt,
          Icons.camera_alt
        ],
        secondaryIconsText: const [
          '3x3',
          '4x4',
          'Todas',
          'Cancelar',
          'Cancelar consulta',
          'Realizar consulta',
          'Realizar captura'
        ],
        secondaryIconsOnPress: [
          () => {setSize(0)},
          () => {setSize(1)},
          () => {setSize(2)},
          () => {setSize(3)},
          () => {
                EasyLoading.showInfo('Filtro cancelado',
                        maskType: EasyLoadingMaskType.custom,
                        duration: const Duration(milliseconds: 3000),
                        dismissOnTap: true)
                    .then(
                  (value) {
                    setState(() => _filter = '');
                  },
                )
              },
          () => {
                setState(() => _filter = ''),
                Navigator.push(context, MaterialPageRoute<String>(
                  builder: (BuildContext context) {
                    return const FilterStores();
                  },
                )).then((value) {
                  if (value != null) {
                    print(value);
                    setState(() {
                      _filter += value;
                      super.widget;
                    });
                  }
                })
              },
          () => {
                print("Captura realizada"),
                _screenshotController
                    .capture(delay: const Duration(milliseconds: 10))
                    .then((Uint8List? image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final imagePath =
                      await File('${directory.path}/estado.png').create();
                  await imagePath.writeAsBytes(image!);
                  await Share.shareFiles([imagePath.path],
                      text: 'Estado global de las tiendas',
                      subject:
                          'Vista global del estado actual de las tiendas.');
                }).catchError((onError) {
                  print(onError);
                })
              }
        ],
        secondaryBackgroundColor: Colors.blueGrey,
        secondaryForegroundColor: Colors.orange,
        primaryBackgroundColor: Colors.orange,
        primaryForegroundColor: Colors.white,
      ),
    );
  }

  void setSize(int index) {
    setState(() {
      if (index == 2) {
        _visible = false;
        _visibleItem = false;
      } else {
        _visible = index != 3;
        _visibleItem = true;
      }

      _crossAxisCount = sizes[index].crossAxisCount!;
      _fontSize = sizes[index].fontSize!;
      _minFontSize = sizes[index].minFontSize!;
      _maxFontSize = sizes[index].maxFontSize!;
      _iconSize = sizes[index].iconSize!;
    });
  }

  TableRow _tableRow(
      String description, Color color, String quantity, double fontSize) {
    return TableRow(children: [
      Column(children: <Widget>[
        Text(
          description,
          style: TextStyle(color: color, fontSize: fontSize),
        )
      ]),
      Column(children: [
        Text(
          quantity,
          style:
              TextStyle(color: _colors.textColor(context), fontSize: fontSize),
        )
      ]),
    ]);
  }

  Container infoContainer(IconData icon, String label, String text) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          NeumorphicIcon(
            icon,
            size: 18,
            style: NeumorphicStyle(
                color: _colors.iconsColor(context),
                shape: NeumorphicShape.flat,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                shadowLightColor: _colors.shadowColor(context),
                depth: 1.5,
                intensity: 0.7),
          ),
          Text(
            ' $label',
            style: TextStyle(
              color: _colors.textColor(context),
              fontSize: 14,
            ),
          ),
          Text(
            ' $text',
            style: TextStyle(
                color: _colors.textColor(context),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _autoSizeText(String label, bool visible) {
    return Visibility(
      visible: visible,
      child: AutoSizeText(
        label,
        maxLines: 1,
        minFontSize: _minFontSize,
        maxFontSize: _maxFontSize,
        style: TextStyle(fontSize: _fontSize),
      ),
    );
  }

  Widget _assignedStoresCard(List<StoreData> storeData, int index) {
    var user = Usuario(
        id: 0,
        dni: 0,
        nombre: 'Sin asignar',
        apellidos: '',
        celular: 0,
        email: '');

    var city = Ciudad(id: 0, nombre: '');

    var inc = Incidentes(
        masivo: false,
        serviciosCaidos: 0,
        ultimaObservacion: 'Sin observaciones actuales');

    var store = StoreData(
        id: storeData[index].id ?? 0,
        nombre: storeData[index].nombre ?? 'Sin asignar',
        estado: storeData[index].estado ?? 0,
        ciudad: storeData[index].ciudad ?? city,
        descEstado: storeData[index].descEstado ?? 'Cerrada',
        incidentes: storeData[index].incidentes ?? inc,
        usuario: storeData[index].usuario ?? user);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute<bool>(
          builder: (BuildContext context) {
            return StoreDetails(storeData: store);
          },
        )).then((value) => {
              if (value == true) {setState(() => _filter = ''), super.widget}
            }); //StoreDetails(storeData: storeData[index]);
      },
      child: Tooltip(
        message: store.nombre!,
        child: Container(
          decoration: BoxDecoration(
              color: store.incidentes!.masivo == true
                  ? Colors.red[600]
                  : Colors.transparent,
              border: Border.all(
                  color: store.incidentes!.serviciosCaidos! > 1
                      ? Colors.redAccent
                      : Colors.blueGrey)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _autoSizeText(store.ciudad!.nombre!, _visibleItem),
                  Icon(
                    Icons.store,
                    color: store.estado == 0
                        ? Colors.blueGrey
                        : store.incidentes!.serviciosCaidos! > 0
                            ? Colors.orangeAccent
                            : Colors.green,
                    size: _iconSize,
                  ),
                  _autoSizeText(store.descEstado!, _visibleItem),
                ],
              ),
              _autoSizeText(
                  '${store.usuario!.nombre!} ${store.usuario!.apellidos!}',
                  _visible),
              _autoSizeText(store.nombre!, _visibleItem),
              _autoSizeText(
                  'Fallas: ${store.incidentes!.serviciosCaidos}', _visibleItem),
            ],
          ),
        ),
      ),
    );
  }
}
