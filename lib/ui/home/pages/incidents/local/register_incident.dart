import 'package:embajadores/data/controllers/formhelper.dart';
import 'package:embajadores/data/models/assigned.dart';
import 'package:embajadores/data/models/failtypes.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/models/owner.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/data/services/db_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

GlobalKey<_RegisterIncidentState> registerIncidentKey = GlobalKey();

class RegisterIncident extends StatefulWidget {
  const RegisterIncident({Key? key, this.owner, this.index}) : super(key: key);
  final Owner? owner;
  final int? index;
  @override
  _RegisterIncidentState createState() => _RegisterIncidentState();
}

class _RegisterIncidentState extends State<RegisterIncident> {
  final _affectedUsersController = TextEditingController();
  final _formKeyCard = GlobalKey<FormBuilderState>();
  final _notesController = TextEditingController();
  final _usersController = TextEditingController();
  final CustomColors _colors = CustomColors();
  final List<int>? _selectedComponents = [];
  List<Component>? _listComponents = [];
  APIService apiService = APIService();
  ReportIncident? _reportIncident;
  final prefs = UserPreferences();
  var _notes = "Sin comentarios";
  List<TargetFocus> targets = [];
  var keyCancel = GlobalKey();
  bool _checkboxVal = false;
  var keyHelp = GlobalKey();
  var keySave = GlobalKey();
  int? _selectedFailTypeId;
  int? _selectedServiceId;
  int? _selectedStoreId;
  int? _selectedStatus;
  int _affected = 0;
  int _massive = 0;
  int _users = 0;

  @override
  void initState() {
    super.initState();
    if (widget.owner != null) {
      _selectedStoreId = widget.owner!.id;
    }
    _reportIncident = ReportIncident();
    if (prefs.firstIncident == true) {
      Future.delayed(const Duration(microseconds: 3000)).then((value) {
        setTutorial();
        showTutorial();
      });
      prefs.firstIncident = false;
    }
  }

  void clearComponentList() {
    setState(() {
      _selectedComponents!.clear();
      _listComponents!.clear();
    });
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
    // tutorial.next(); // call next target programmatically
    // tutorial.previous(); // call previous target programmatically
  }

  void setTutorial() {
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.live_help_outlined,
                            color: Colors.cyanAccent),
                      ],
                    ),
                  ),
                  const Text(
                    "Bienvenido",
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
                                    "A continuación, se mostrará el tutorial del registro de incidentes, que describirá a detalle como se debe registrar la información del incidente a reportar. Se recomienda leerlo por completo la primera vez, pero puede omitirlo y verlo cuando lo desee tocando en el icono ",
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
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "",
                      style: TextStyle(color: Colors.white),
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
                  const Text(
                    "Registrar incidente",
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
                              WidgetSpan(
                                  child: Icon(
                                Icons.location_city,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text: " Nombre de la tienda\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.supervised_user_circle,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Escriba cantidad de usuarios en operación\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.check_box_outlined,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text: " Seleccione el estado actual (*)\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.supervised_user_circle_outlined,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Escriba cantidad de usuarios afectados\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.miscellaneous_services,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text: " Seleccione el servicio afectado\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.settings_input_component,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text: " Seleccione los componentes afectados\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.check_box_outlined,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Si la falla es masiva, marque la casilla '¿Incidente masivo?'\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.error_outline,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text: " Seleccione tipo de falla\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.note,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Agregue detalles del incidente (Opcional)\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.check_box_outlined,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Verifica la validéz de la información suministrada.\n\n\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.check_box_outlined,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Registrar incidente adicional (Solo si lo requiere).\n\n\n",
                              ),
                              TextSpan(
                                text:
                                    "(*) Estados de incidente (Seleccione):\nPendiente: El campo usuarios afectados no será mostrado y la información queda pendiente por ingreso. Podrá actualizar esta información en la actualización o cierre del incidente.\nEn curso: Si el incidente está actualmente en curso y no ha sido solucionado.\nCerrado: Si el incidente reportado es informativo o ya fue solucionado.",
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
                    "Registrar incidente/Agregar incidente adicional",
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
                                    "Registra los datos diligenciados en línea. Si la casilla de Registrar incidente adcional está marcada, esta pantalla no se cerrará y podrá registrar varios incidentes.",
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
                                    "Cancela la operación de registro de incidente actual.",
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: NeumorphicAppBar(
          leading: Container(
            padding: const EdgeInsets.all(5),
            child: Stack(
              children: <Widget>[
                NeumorphicIcon(
                  Icons.app_registration,
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
                'Registrar incidente',
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
                    setTutorial();
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
        body: SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: FormBuilder(
                  key: _formKeyCard,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.store,
                              color: _colors.iconsColor(context),
                              size: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Text(widget.owner!.store!),
                            )
                          ],
                        ),
                      ),
                      FormBuilderTextField(
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
                        onChanged: (value) {
                          _users = int.parse(value!);
                        },
                      ),
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
                                        labelText: 'Estado actual',
                                        prefixIcon: Icon(
                                            Icons.check_box_outlined,
                                            color: _colors.iconsColor(context),
                                            size: 18)),
                                    hint:
                                        const Text('Seleccionar estado actual'),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context,
                                          errorText: 'Estado actual requerido')
                                    ]),
                                    items: snapshot.data!
                                        .map((serviceStatus) =>
                                            DropdownMenuItem<ServiceStatus>(
                                                child:
                                                    Text(serviceStatus.nombre!),
                                                value: serviceStatus))
                                        .toList(),
                                    onChanged: (serviceStatus) {
                                      setState(() {});
                                      _selectedStatus = serviceStatus!.id;
                                    },
                                  );
                          }),
                      Visibility(
                        visible: _selectedStatus != 1,
                        child: FormBuilderTextField(
                          controller: _affectedUsersController,
                          name: 'afecttedusers',
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText:
                                    'Cantidad de usuarios afeactos requerida'),
                            FormBuilderValidators.notEqual(context, '0',
                                errorText:
                                    'La cantidad de usuarios no puede ser de 0'),
                            FormBuilderValidators.max(context, _users,
                                inclusive: true,
                                errorText:
                                    'La cantidad de usuarios afectados es mayor a la de usuarios')
                          ]),
                          decoration: InputDecoration(
                              labelText: 'Usuarios afectados',
                              prefixIcon: Icon(
                                Icons.supervised_user_circle_outlined,
                                color: _colors.iconsColor(context),
                                size: 18,
                              )),
                          onChanged: (value) {
                            if (value != '') {
                              _affected = int.parse(value!);
                            }
                          },
                        ),
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
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context,
                                          errorText:
                                              'Servicio afectado requerido')
                                    ]),
                                    items: snapshot.data!
                                        .map((service) =>
                                            DropdownMenuItem<ServiceInfo>(
                                                child: Text(service.nombre!),
                                                value: service))
                                        .toList(),
                                    onChanged: (service) {
                                      setState(() {
                                        _selectedServiceId = service!.id;
                                      });
                                    },
                                  );
                          }),
                      _selectedServiceId != null
                          ? FutureBuilder<List<Component>>(
                              future:
                                  apiService.getComponents(_selectedServiceId!),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Component>> snapshot) {
                                return !snapshot.hasData
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: MultiSelectBottomSheetField(
                                          initialChildSize: 0.4,
                                          searchHint: "Buscar...",
                                          searchable: true,
                                          buttonIcon: const Icon(
                                              Icons.arrow_drop_down_outlined),
                                          decoration: BoxDecoration(
                                            color: _colors.iconsColor(context),
                                          ),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          backgroundColor:
                                              _colors.contextColor(context),
                                          itemsTextStyle: TextStyle(
                                              color:
                                                  _colors.textColor(context)),
                                          selectedColor:
                                              _colors.textColor(context),
                                          selectedItemsTextStyle: TextStyle(
                                              color:
                                                  _colors.textColor(context)),
                                          title: const Text(
                                              "Componente que falla"),
                                          buttonText: const Text(
                                              "Seleccionar componentes que fallan"),
                                          cancelText: const Text("Cancelar"),
                                          confirmText:
                                              const Text("Seleccionar"),
                                          items: snapshot.data!
                                              .map((type) =>
                                                  MultiSelectItem<Component>(
                                                      type, type.nombre!))
                                              .toList(),
                                          onConfirm: (values) {
                                            setState(() {
                                              _listComponents =
                                                  values.cast<Component>();
                                              for (var value
                                                  in _listComponents!) {
                                                _selectedComponents!
                                                    .add(value.id!);
                                              }
                                            });
                                          },
                                          chipDisplay: MultiSelectChipDisplay(
                                            chipColor:
                                                _colors.iconsColor(context),
                                            textStyle: const TextStyle(
                                                color: Colors.white),
                                            onTap: (ServiceInfo? value) {
                                              setState(() {
                                                _listComponents!.remove(value);
                                                _selectedComponents!
                                                    .remove(value!.id);
                                              });
                                            },
                                          ),
                                        ),
                                      );
                              })
                          : Container(),
                      FormBuilderCheckbox(
                        name: 'massive',
                        activeColor: _colors.iconsColor(context),
                        title: const Text("¿Incidente masivo?"),
                        onChanged: (value) {
                          _massive = value == true ? 1 : 0;
                        },
                      ),
                      FutureBuilder<List<FailTypes>>(
                          future: apiService.getFailTypes(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<FailTypes>> snapshot) {
                            return !snapshot.hasData
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : FormBuilderDropdown<FailTypes>(
                                    name: 'failtype',
                                    decoration: InputDecoration(
                                        labelText: 'Tipo de falla',
                                        prefixIcon: Icon(
                                            Icons.report_gmailerrorred_sharp,
                                            color: _colors.iconsColor(context),
                                            size: 18)),
                                    hint:
                                        const Text('Seleccionar tipo de falla'),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context,
                                          errorText: 'Tipo de falla requerido')
                                    ]),
                                    items: snapshot.data!
                                        .map((fail) =>
                                            DropdownMenuItem<FailTypes>(
                                                child: Text(fail.nombre!),
                                                value: fail))
                                        .toList(),
                                    onChanged: (fail) {
                                      _selectedFailTypeId = fail!.id;
                                    },
                                  );
                          }),
                      FormBuilderTextField(
                          name: 'notes',
                          controller: _notesController,
                          maxLines: 5,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            counterText:
                                '${_notesController.text.split(' ').length} palabra(s)',
                            labelText: 'Notas adicionales:(Opcional)',
                            hintText: ('Opcional...'),
                            border: const OutlineInputBorder(),
                            hoverColor: _colors.iconsColor(context),
                          ),
                          onChanged: (value) => _notes = value!),
                      const Divider(),
                      FormBuilderCheckbox(
                        name: 'ensure',
                        activeColor: _colors.iconsColor(context),
                        title: const Text(
                            "Toda la información ingresada es válida"),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText:
                                  "Debe certificar que toda la información ingresada es válida")
                        ]),
                      ),
                      FormBuilderCheckbox(
                        name: 'add+',
                        activeColor: _colors.iconsColor(context),
                        title: const Text("Registrar incidente adicional"),
                        onChanged: (value) {
                          setState(() => _checkboxVal = value!);
                        },
                      ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
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
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: _colors.shadowColor(context),
                    depth: 2,
                    intensity: 1),
                tooltip: 'Registrar tienda',
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: Stack(
                    children: <Widget>[
                      NeumorphicIcon(
                        Icons.fmd_bad,
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
                      Positioned(
                        right: 0,
                        top: 18,
                        child: _checkboxVal
                            ? NeumorphicIcon(
                                Icons.add,
                                size: 35,
                                style: NeumorphicStyle(
                                    color: _colors.iconsInvertColor(context),
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(10)),
                                    shadowLightColor:
                                        _colors.shadowColor(context),
                                    depth: 1.5,
                                    intensity: 0.7),
                              )
                            : NeumorphicIcon(
                                Icons.save,
                                size: 35,
                                style: NeumorphicStyle(
                                    color: _colors.iconsInvertColor(context),
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(10)),
                                    shadowLightColor:
                                        _colors.shadowColor(context),
                                    depth: 1.5,
                                    intensity: 0.7),
                              ),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  saveAndValidate(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveAndValidate(BuildContext context) {
    if (_formKeyCard.currentState!.saveAndValidate()) {
      if (_notes == '') _notes = 'Sin comentarios';
      if (_listComponents!.isEmpty) {
        EasyLoading.showInfo('Seleccione cuales componentes están fallando.',
            maskType: EasyLoadingMaskType.custom,
            duration: const Duration(milliseconds: 5000),
            dismissOnTap: true);
      } else {
        _reportIncident!.tipo = 1;
        _reportIncident!.idTienda = _selectedStoreId;
        _reportIncident!.idServicio = _selectedServiceId;
        _reportIncident!.masivo = _massive;
        _reportIncident!.idTipoFalla = _selectedFailTypeId;
        _reportIncident!.componentes = _selectedComponents;
        _reportIncident!.usuariosOperacion = _users;
        _reportIncident!.usuariosAfectados = _affected;
        _reportIncident!.idEstado = _selectedStatus;
        _reportIncident!.fechaApertura = DateTime.now();
        _reportIncident!.fechaCierre = DateTime.now();
        _reportIncident!.observacion = _notes;

        print(_reportIncident!.tipo);
        print(_reportIncident!.idTienda);
        print(_reportIncident!.idServicio);
        print(_reportIncident!.masivo);
        print(_reportIncident!.idTipoFalla);
        print(_reportIncident!.componentes);
        print('Usuarios en operación ${_reportIncident!.usuariosOperacion}');
        print('Usuarios afectados ${_reportIncident!.usuariosAfectados}');
        print(_reportIncident!.idEstado);
        print(_reportIncident!.fechaApertura);
        print(_reportIncident!.fechaCierre);
        print(_reportIncident!.observacion);

        apiService.registerIncident(_reportIncident!).then((value) {
          if (value.status == true) {
            EasyLoading.showInfo('Incidente reportado exitosamente.',
                maskType: EasyLoadingMaskType.custom,
                duration: const Duration(milliseconds: 5000),
                dismissOnTap: true);
            if (_checkboxVal == true) {
              _formKeyCard.currentState!.reset();
              _affectedUsersController.clear();
              _notesController.clear();
              clearComponentList();
            } else {
              setState(() {
                Navigator.pop(context, true);
              });
            }
          }
        });
      }
    }
  }
}
