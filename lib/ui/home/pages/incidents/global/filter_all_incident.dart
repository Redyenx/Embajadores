import 'package:embajadores/data/controllers/formhelper.dart';
import 'package:embajadores/data/models/assigned.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:embajadores/data/models/cities_stores.dart';
import 'package:embajadores/data/models/failtypes.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class FilterAllIncidents extends StatefulWidget {
  const FilterAllIncidents({Key? key}) : super(key: key);

  @override
  _FilterAllIncidentsState createState() => _FilterAllIncidentsState();
}

class _FilterAllIncidentsState extends State<FilterAllIncidents> {
  final onSelectedType = {
    '1': 'Reporte de incidente',
    '2': 'Apertura de tienda',
    '3': 'Cierre de tienda'
  };
  final onOperationStatus = {'0': 'Cerrada', '1': 'Abierta'};
  final CustomColors _colors = CustomColors();
  APIService apiService = APIService();
  DateTime dateTime = DateTime.now();
  final prefs = UserPreferences();
  List<TargetFocus> targets = [];
  var keyCancel = GlobalKey();
  var keyHelp = GlobalKey();
  var keySave = GlobalKey();
  var _enableStore = false;
  int selectedService = 0;
  var massive = false;
  String? _startDate;
  String? _endDate;
  int? onOperation;
  var storeId = 0;
  var filter = '';
  int? cityId = 0;
  var status = 0;
  int type = 1;
  var fs = '%26%26';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (prefs.firstIncidentFilter == true) {
      Future.delayed(const Duration(microseconds: 3000)).then((value) {
        setMainTutorial();
        showTutorial();
      });
      prefs.firstIncidentFilter = false;
    }
  }

  void showTutorial() {
    TutorialCoachMark tutorial = TutorialCoachMark(context,
        targets: targets, // List<TargetFocus>
        colorShadow: Colors.black, // DEFAULT Colors.black
        // alignSkip: Alignment.bottomRight,
        textSkip: "Omitir",
        // paddingFocus: 10,
        // focusAnimationDuration: Duration(milliseconds: 500),
        // pulseAnimationDuration: Duration(milliseconds: 500),
        // pulseVariation: Tween(begin: 1.0, end: 0.99),
        onFinish: () {}, onClickTarget: (target) {
      print(target);
    }, onSkip: () {
      EasyLoading.showInfo('Tutorial omitido por el usuario.',
          maskType: EasyLoadingMaskType.custom,
          duration: const Duration(milliseconds: 1000));
    })
      ..show();
    // tutorial.skip();
    // tutorial.finish();
    // tutorial.next(call next target programmatically
    // tutoriaious(); // call previous target programmatically
  }

  void setMainTutorial() {
    targets.clear();
    targets.add(TargetFocus(
        identify: "Target 0",
        keyTarget: keyHelp,
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Consultar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.justify,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "A continuación, se mostrará el tutorial de la pantalla Consultar, este módulo le permitirá filtrar los registros de la pantalla Reportes.\nSe recomienda leerlo por completo la primera vez, pero puede omitirlo y verlo cuando lo desee tocando en el icono ",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.help_outline,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " en la parte superior derecha de la pantalla. Recuerde que los tutoriales se dividen por sección.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Toque en cualquier parte para continuar.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]));
    targets.add(TargetFocus(
        identify: "Target 1",
        keyTarget: keyHelp,
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.justify,
                          text: const TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Icon(
                                Icons.date_range,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Filtrar por rangos de fecha los cuales filtrarán los registros disponibles entre las fechas seleccionadas.\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.lock_open,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Filtrar por tipo de registro (Apertura de tienda, Cierre de tienda, Incidente)\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.location_city,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text: " Filtrar por ciudad\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.store,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Filtrar por estado de la tienda (Abierta, Cerrada)\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.miscellaneous_services,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text: " Filtrar por servicio afectado\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.check_box_outlined,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Filtrar por estado de incidente (Cerrado, En curso, Pendiente)\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.error,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Filtrar por registro de incidentes masivos\n\n\n",
                              ),
                              TextSpan(
                                text:
                                    "Puede establecer varios filtros al tiempo para especificar los datos deseados.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Toque en cualquier parte para finalizar.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]));
    targets.add(TargetFocus(
        identify: "Target 2",
        keyTarget: keySave,
        shape: ShapeLightFocus.RRect,
        alignSkip:
            AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Toque en cualquier parte para continuar.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Enviar filtro",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.justify,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Envía el filtro establecido con las opciones seleccionadas, este se verá reflejado en la pantalla de Reportes.\nSi envía el filtro en sin opciones, se utilizará el filtro por defecto.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]));
    targets.add(TargetFocus(
        identify: "Target 4",
        keyTarget: keyCancel,
        shape: ShapeLightFocus.RRect,
        alignSkip:
            AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Toque en cualquier parte para finalizar.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Cancelar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    //color: Colors.deepPurpleAccent,
                    //height: 200,
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.justify,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Cancela la operación actual y regresa a la pantalla anterior.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
        theme: NeumorphicThemeData(
          lightSource: LightSource.topLeft,
          accentColor: NeumorphicColors.accent,
          appBarTheme: NeumorphicAppBarThemeData(
              buttonStyle: NeumorphicStyle(
                color: _colors.iconsColor(context),
                shadowLightColor: _colors.iconsColor(context),
                boxShape: const NeumorphicBoxShape.circle(),
                shape: NeumorphicShape.flat,
                depth: 2,
                intensity: 0.9,
              ),
              textStyle:
                  TextStyle(color: _colors.textColor(context), fontSize: 12),
              iconTheme:
                  IconThemeData(color: _colors.textColor(context), size: 25)),
          depth: 1,
          intensity: 5,
        ),
        child: Scaffold(
          appBar: NeumorphicAppBar(
            leading: Container(
              padding: const EdgeInsets.all(5),
              child: Stack(
                children: <Widget>[
                  NeumorphicIcon(
                    Icons.youtube_searched_for,
                    size: 50,
                    style: NeumorphicStyle(
                        color: _colors.iconsColor(context),
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(10)),
                        shadowLightColor: _colors.shadowColor(context),
                        depth: 1.5,
                        intensity: 0.7),
                  ),
                ],
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NeumorphicText(
                  'Consultar',
                  //key: keyWelcome,
                  style: NeumorphicStyle(
                    color: _colors.iconsColor(context),
                    intensity: 0.7,
                    depth: 1.5,
                    shadowLightColor: _colors.shadowColor(context),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  FormHelper.showMessage(
                    context,
                    "Embajadores",
                    "¿Ver tutorial de la sección?",
                    "Si",
                    () {
                      setMainTutorial();
                      showTutorial();
                      Navigator.of(context).pop();
                    },
                    buttonText2: "No",
                    isConfirmationDialog: true,
                    onPressed2: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: NeumorphicIcon(
                    Icons.help_outline,
                    key: keyHelp,
                    size: 40,
                    style: NeumorphicStyle(
                        color: _colors.iconsColor(context),
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(10)),
                        shadowLightColor: _colors.shadowColor(context),
                        depth: 1.5,
                        intensity: 0.7),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height * 1.1,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                child: FormBuilder(
                  child: Column(
                    children: <Widget>[
                      SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.range,
                      ),
                      FormBuilderDropdown(
                        name: 'type',
                        decoration: InputDecoration(
                            labelText: 'Tipo',
                            prefixIcon: Icon(Icons.lock_open,
                                color: _colors.iconsColor(context), size: 18)),
                        hint: const Text('Seleccionar tipo de registro'),
                        items: onSelectedType.entries
                            .map<DropdownMenuItem<String>>(
                                (MapEntry<String, String> e) =>
                                    DropdownMenuItem<String>(
                                      value: e.key,
                                      child: Text(e.value),
                                    ))
                            .toList(),
                        onChanged: (value) {
                          type = int.parse(value.toString());
                          print(value);
                        },
                      ),
                      FutureBuilder<List<City>>(
                          future: apiService.getCities(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<City>> snapshot) {
                            return !snapshot.hasData
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : FormBuilderDropdown<City>(
                                    name: 'city',
                                    //initialValue: _listCity.first,
                                    decoration: InputDecoration(
                                        labelText: 'Ciudad',
                                        prefixIcon: Icon(Icons.location_city,
                                            color: _colors.iconsColor(context),
                                            size: 18)),
                                    hint: const Text('Seleccionar ciudad'),
                                    items: snapshot.data!
                                        .map((city) => DropdownMenuItem<City>(
                                            child: Text(city.nombre!),
                                            value: city))
                                        .toList(),
                                    onChanged: (city) {
                                      if (city != null) {
                                        setState(() {
                                          cityId = city.id!;
                                          _enableStore = true;
                                        });
                                      }
                                    },
                                  );
                          }),
                      Visibility(
                        visible: _enableStore,
                        child: FutureBuilder<List<Stores>>(
                            future: apiService.getStoresFromCities(cityId!),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Stores>> snapshot) {
                              return !snapshot.hasData
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : FormBuilderDropdown<Stores>(
                                      name: 'stores',
                                      decoration: InputDecoration(
                                          labelText: 'Tienda',
                                          prefixIcon: Icon(Icons.store,
                                              color:
                                                  _colors.iconsColor(context),
                                              size: 18)),
                                      hint: const Text('Seleccionar tienda'),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(context,
                                            errorText: 'Tienda requerida')
                                      ]),
                                      items: snapshot.data!
                                          .map((stores) =>
                                              DropdownMenuItem<Stores>(
                                                  value: stores,
                                                  child: Text(stores.nombre!)))
                                          .toList(),
                                      onChanged: (stores) {
                                        if (stores != null) {
                                          storeId = stores.id!;
                                        }
                                      },
                                    );
                            }),
                      ),
                      FormBuilderDropdown(
                        name: 'operate',
                        decoration: InputDecoration(
                            labelText: 'Estado de la tienda',
                            prefixIcon: Icon(Icons.lock_open,
                                color: _colors.iconsColor(context), size: 18)),
                        hint: const Text('Seleccionar por estado de la tienda'),
                        items: onOperationStatus.entries
                            .map<DropdownMenuItem<String>>(
                                (MapEntry<String, String> e) =>
                                    DropdownMenuItem<String>(
                                      value: e.key,
                                      child: Text(e.value),
                                    ))
                            .toList(),
                        onChanged: (value) {
                          onOperation = int.parse(value.toString());
                          print(value);
                        },
                      ),
                      FutureBuilder<List<ServiceInfo>>(
                          future: apiService.getServices(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ServiceInfo>> snapshot) {
                            return !snapshot.hasData
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : FormBuilderDropdown<ServiceInfo>(
                                    name: 'service',
                                    decoration: InputDecoration(
                                        labelText: 'Servicio afectado',
                                        prefixIcon: Icon(
                                            Icons.miscellaneous_services,
                                            color: _colors.iconsColor(context),
                                            size: 18)),
                                    hint: const Text(
                                        'Seleccionar servicio afectado'),
                                    items: snapshot.data!
                                        .map((service) =>
                                            DropdownMenuItem<ServiceInfo>(
                                                child: Text(service.nombre!),
                                                value: service))
                                        .toList(),
                                    onChanged: (service) {
                                      selectedService = service!.id!;
                                    },
                                  );
                          }),
                      FutureBuilder<List<ServiceStatus>>(
                          future: apiService.getServiceStatus(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ServiceStatus>> snapshot) {
                            return !snapshot.hasData
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : FormBuilderDropdown<ServiceStatus>(
                                    name: 'actualStatus',
                                    decoration: InputDecoration(
                                        labelText: 'Estado del incidente',
                                        prefixIcon: Icon(
                                            Icons.check_box_outlined,
                                            color: _colors.iconsColor(context),
                                            size: 18)),
                                    hint: const Text(
                                        'Seleccionar estado del incidente'),
                                    items: snapshot.data!
                                        .map((serviceStatus) =>
                                            DropdownMenuItem<ServiceStatus>(
                                                child:
                                                    Text(serviceStatus.nombre!),
                                                value: serviceStatus))
                                        .toList(),
                                    onChanged: (serviceStatus) {
                                      status = serviceStatus!.id!;
                                    },
                                  );
                          }),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            NeumorphicIcon(
                              Icons.error,
                              size: 20,
                              style: NeumorphicStyle(
                                  color: _colors.iconsColor(context),
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(10)),
                                  shadowLightColor:
                                      _colors.shadowColor(context),
                                  depth: 1,
                                  intensity: 0.7),
                            ),
                            const Text('Incidentes masivos'),
                            Switch(
                                activeColor: _colors.iconsColor(context),
                                value: massive,
                                onChanged: (value) {
                                  setState(() {});
                                  massive = !massive;
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                NeumorphicFloatingActionButton(
                  key: keyCancel,
                  style: NeumorphicStyle(
                      color: _colors.contextColor(context),
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                      shadowLightColor: _colors.shadowColor(context),
                      depth: 2,
                      intensity: 1),
                  tooltip: 'Cancelar',
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.cancel,
                      color: _colors.iconsColor(context),
                      size: 30,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                NeumorphicFloatingActionButton(
                  key: keySave,
                  style: NeumorphicStyle(
                      color: _colors.contextColor(context),
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                      shadowLightColor: _colors.shadowColor(context),
                      depth: 2,
                      intensity: 1),
                  tooltip: 'Enviar filtro',
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.filter_list_alt,
                      color: _colors.iconsColor(context),
                      size: 30,
                    ),
                  ),
                  onPressed: () {
                    _startDate ??=
                        DateTime(dateTime.year, dateTime.month, 1).toString();
                    _endDate ??= DateTime(dateTime.year, dateTime.month,
                            dateTime.day, 23, 59, 59, 999)
                        .toString();
                    if (type > 0) {
                      filter += 'inc_tipo=$type';
                    }
                    if (_startDate != null) {
                      filter +=
                          '${fs}inc_fecha_apertura>=' "'" '$_startDate' "'";
                    }
                    if (_endDate != null) {
                      filter += '${fs}inc_fecha_cierre<=' "'" '$_endDate' "'";
                    }
                    if (cityId != 0) {
                      filter += '${fs}id_ciudad=$cityId';
                    }
                    if (onOperation != null) {
                      filter += '${fs}tie_estado_operacion=$onOperation';
                    }
                    if (storeId > 0) {
                      filter += '${fs}id_tienda=$storeId';
                    }
                    if (status > 0) {
                      filter += '${fs}id_estado=$status';
                    }
                    if (selectedService > 0) {
                      filter += '${fs}id_servicio=$selectedService';
                    }
                    if (massive == true) {
                      var masivo = massive == true ? 1 : 0;
                      filter += '${fs}inc_masivo=$masivo';
                    }
                    print(filter);
                    print(DateTime.now());

                    Navigator.pop(context, filter);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _startDate = DateFormat('yyyy/MM/dd hh:mm')
            .format(args.value.startDate)
            .toString();
        _endDate = DateFormat('yyyy/MM/dd hh:mm')
            .format(args.value.endDate ?? args.value.startDate)
            .toString();
      }
    });
  }
}
