import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:embajadores/data/controllers/formhelper.dart';
import 'package:embajadores/data/controllers/themenotifier.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/models/owner.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/data/services/db_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:embajadores/ui/home/pages/incidents/local/register_incident.dart';
import 'package:embajadores/ui/home/pages/stores/register_store.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyStores extends StatefulWidget {
  const MyStores({Key? key}) : super(key: key);
  //final
  @override
  _MyStoresState createState() => _MyStoresState();
}

class _MyStoresState extends State<MyStores> {
  final _notesController = TextEditingController();
  final _usersController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final CustomColors _colors = CustomColors();
  final APIService _apiService = APIService();
  final prefs = UserPreferences();
  OpenCloseStore? _openCloseStore;
  String? jsonCategories;
  DBService? _dbService;
  Owner? _ownerModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openCloseStore = OpenCloseStore();
    _dbService = DBService();
    _ownerModel = Owner();
    getStoresByOwner();
  }

  Future<List<Owner>> getStoresByOwner() async {
    final counter = Provider.of<CounterProvider>(context, listen: false);
    var data = _dbService!.getOwner();
    await data.then((value) {
      prefs.ownerCount = value.length;
      counter.onChange(value.length);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Owner>>(
            future: getStoresByOwner(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Owner>> snapshot) {
              return !snapshot.hasData
                  ? const SizedBox(
                      height: 500,
                      child: Center(child: CircularProgressIndicator()))
                  : SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 120),
                        child: Wrap(
                          children: <Widget>[
                            ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _assignedStoresCard(
                                    context, snapshot.data!, index);
                              },
                            ),
                          ],
                        ),
                      ));
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: NeumorphicFloatingActionButton(
        //key: keyCancel,
        mini: true,
        style: NeumorphicStyle(
            color: _colors.contextColor(context),
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
            shadowLightColor: _colors.shadowColor(context),
            depth: 2,
            intensity: 1),
        tooltip: 'Cancelar',
        child: Container(
          margin: const EdgeInsets.all(2),
          child: Icon(
            Icons.add,
            color: _colors.iconsColor(context),
            size: 30,
          ),
        ),
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute<bool>(
            builder: (BuildContext context) {
              return RegisterStore();
            },
          )).then((value) {
            if (value == true) {
              setState(() => super.widget);
            }
          });
        },
      ),
    );
  }

  Widget _assignedStoresCard(
      BuildContext context, List<Owner> storeDetails, int index) {
    var storeCity = storeDetails[index].city.toString();
    var storeId = storeDetails[index].id;
    var time = storeDetails[index].time!;
    final now = DateTime.now();
    final difference = now.difference(DateTime.parse(time));
    final fifteenAgo = DateTime.now().subtract(difference);
    var storeName = storeDetails[index].store.toString();
    var storeStatus = storeDetails[index].status.toString();
    var storeNotes = storeDetails[index].notes.toString();

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: ExpansionTileCard(
        leading: SizedBox(
          width: 40,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              NeumorphicIcon(
                Icons.store,
                size: 40,
                style: NeumorphicStyle(
                    color: storeStatus == 'Cerrada'
                        ? Colors.redAccent
                        : Colors.green,
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: storeStatus == 'Cerrada'
                        ? Colors.red
                        : Colors.greenAccent,
                    depth: 1,
                    intensity: 0.7),
              ),
              Text(
                storeStatus == 'Cerrada' ? 'Cerrada' : 'Abierta',
                style: const TextStyle(fontSize: 8),
              )
            ],
          ),
        ),
        title: Container(
          width: 200,
          height: 50,
          padding: const EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.label,
                    color: _colors.iconsColor(context),
                    size: 15,
                  ),
                  AutoSizeText(
                    ' $storeName',
                    maxLines: 2,
                    minFontSize: 4,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_city,
                    color: _colors.iconsColor(context),
                    size: 15,
                  ),
                  AutoSizeText(
                    ' $storeCity',
                    maxLines: 2,
                    minFontSize: 7,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: _colors.iconsColor(context),
                    size: 15,
                  ),
                  Text(
                    ' $storeStatus ' + timeago.format(fifteenAgo, locale: 'es'),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: SizedBox(
          width: 110,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    _ownerModel!.id = storeId;
                    _ownerModel!.store = storeName;
                    _ownerModel!.city = storeCity;
                    _ownerModel!.status = storeStatus;
                    _ownerModel!.time = DateTime.now().toString();
                    _updateStoreStatusDialog(context, _ownerModel!);
                  },
                  child: Column(
                    children: <Widget>[
                      (storeStatus == 'Cerrada')
                          ? NeumorphicIcon(
                              Icons.login,
                              size: 40,
                              style: NeumorphicStyle(
                                  color: Colors.green,
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(10)),
                                  shadowLightColor: Colors.greenAccent,
                                  depth: 1,
                                  intensity: 0.7),
                            )
                          : NeumorphicIcon(
                              Icons.logout,
                              size: 40,
                              style: NeumorphicStyle(
                                  color: Colors.red,
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(10)),
                                  shadowLightColor: Colors.redAccent,
                                  depth: 1,
                                  intensity: 0.7),
                            )
                    ],
                  )),
              const VerticalDivider(),
              GestureDetector(
                onTap: () {
                  storeStatus == 'Abierta'
                      ? Navigator.push(context, MaterialPageRoute<bool>(
                          builder: (BuildContext context) {
                            return RegisterIncident(
                              owner: storeDetails[index],
                              index: index,
                            );
                          },
                        )).then((value) {
                          if (value == true) {
                            setState(() {
                              super.widget;
                            });
                          }
                        })
                      : EasyLoading.showInfo(
                          'Para reportar incidentes, por favor realice apertura de la tienda.',
                          maskType: EasyLoadingMaskType.custom,
                          duration: const Duration(milliseconds: 3000),
                          dismissOnTap: true);
                },
                child: NeumorphicIcon(
                  Icons.app_registration,
                  size: 40,
                  style: NeumorphicStyle(
                      color: storeStatus == 'Abierta'
                          ? _colors.iconsColor(context)
                          : Colors.grey,
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                      shadowLightColor: _colors.shadowColor(context),
                      depth: 1,
                      intensity: 0.7),
                ),
              ),
            ],
          ),
        ),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: AutoSizeText(
                    'Detalles: \n$storeNotes',
                    maxLines: 3,
                    minFontSize: 4,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: _colors.textColor(context)),
                    overflowReplacement:
                        const Text('La descripción es muy extensa.'),
                  ),
                ),
                Visibility(
                  visible: storeStatus == 'Cerrada',
                  child: GestureDetector(
                    onTap: () {
                      FormHelper.showMessage(
                        context,
                        'Embajadores',
                        '¿Eliminar asignación $storeName?',
                        'Si',
                        () {
                          _ownerModel!.id = storeId;
                          _dbService!.deleteOwner(_ownerModel!).then((value) {
                            setState(() {
                              getStoresByOwner();
                            });
                            Navigator.of(context).pop();
                          });
                        },
                        buttonText2: "No",
                        isConfirmationDialog: true,
                        onPressed2: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: NeumorphicIcon(
                      Icons.delete,
                      size: 40,
                      style: NeumorphicStyle(
                          color: Colors.grey,
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(10)),
                          shadowLightColor: Colors.blueGrey,
                          depth: 1,
                          intensity: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStoreStatusDialog(
      BuildContext context, Owner _ownerModel) async {
    if (_ownerModel.status == 'Cerrada') {
      _notesController.text = 'Apertura de ${_ownerModel.store}';
    } else {
      _usersController.text = '0';
      _notesController.text = 'Cierre de ${_ownerModel.store}';
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              _ownerModel.status == 'Cerrada'
                  ? '¿Realizar apertura de ${_ownerModel.store}?'
                  : '¿Realizar cierre de ${_ownerModel.store}?',
              style: const TextStyle(fontSize: 12),
            ),
            content: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SizedBox(
                height: 180,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      controller: _notesController,
                      name: 'notes',
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Notas: ',
                        hintText: ('No es un campo obligatorio'),
                        border: const OutlineInputBorder(),
                        hoverColor: _colors.iconsColor(context),
                      ),
                    ),
                    Visibility(
                      visible: _ownerModel.status == 'Cerrada',
                      child: FormBuilderTextField(
                        name: 'users',
                        controller: _usersController,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Usuarios en operación requeridos'),
                          FormBuilderValidators.notEqual(context, '0',
                              errorText:
                                  'La cantidad de usuarios no puede ser de 0')
                        ]),
                        decoration: InputDecoration(
                            labelText: 'Usuarios en operación',
                            prefixIcon: Icon(
                              Icons.supervised_user_circle,
                              color: _colors.iconsColor(context),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: _ownerModel.status == 'Cerrada'
                    ? const Text('Apertura')
                    : const Text('Cierre'),
                onPressed: () {
                  if (_formKey.currentState!.saveAndValidate()) {
                    _ownerModel.notes = _notesController.text;
                    _openCloseStore!.tipo =
                        _ownerModel.status == 'Cerrada' ? 2 : 3;
                    if (_ownerModel.status == 'Abierta') {
                      _ownerModel.status = 'Cerrada';
                    } else {
                      _ownerModel.status = 'Abierta';
                    }
                    _openCloseStore!.idTienda = _ownerModel.id;
                    _openCloseStore!.usuariosOperacion =
                        int.parse(_usersController.text);
                    _openCloseStore!.fechaCierre = DateTime.now().toString();
                    _openCloseStore!.fechaApertura = DateTime.now().toString();
                    _openCloseStore!.observacion = _ownerModel.notes;
                    _apiService.openCloseStore(_openCloseStore!).then((value) {
                      if (value.status == true) {
                        EasyLoading.showInfo(
                            _ownerModel.status == 'Cerrada'
                                ? 'La tienda se ha cerrado'
                                : 'La tienda se ha abierto',
                            maskType: EasyLoadingMaskType.custom,
                            duration: const Duration(milliseconds: 1000),
                            dismissOnTap: true);
                        _notesController.clear();
                        _usersController.clear();
                        _dbService!.updateOwner(_ownerModel);
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      } else {
                        EasyLoading.showInfo(
                            'No se pudo cambiar el estado de la tienda',
                            maskType: EasyLoadingMaskType.custom,
                            duration: const Duration(milliseconds: 1000),
                            dismissOnTap: true);
                      }
                    });
                  }
                },
              ),
            ],
          );
        });
  }
}
