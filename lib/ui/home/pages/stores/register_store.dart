import 'package:embajadores/data/controllers/formhelper.dart';
import 'package:embajadores/data/models/cities_stores.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/models/owner.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/data/services/db_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:embajadores/ui/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class RegisterStore extends StatefulWidget {
  const RegisterStore({Key? key}) : super(key: key);

  @override
  _RegisterStoreState createState() => _RegisterStoreState();
}

class _RegisterStoreState extends State<RegisterStore> {
  final _formKeyCard = GlobalKey<FormBuilderState>();
  final _notesController = TextEditingController();
  final _usersController = TextEditingController();
  final CustomColors _colors = CustomColors();
  final APIService _apiService = APIService();
  String _notes = 'Sin comentarios';
  final prefs = UserPreferences();
  OpenCloseStore? _openCloseStore;
  List<TargetFocus> targets = [];
  var keyCancel = GlobalKey();
  var keyAddChk = GlobalKey();
  var keyUsers = GlobalKey();
  var keyHelp = GlobalKey();
  var keyCity = GlobalKey();
  var keySave = GlobalKey();
  bool _checkboxVal = false;
  var _enableStore = false;
  DBService? _dbService;
  String? _storeName;
  Owner? _ownerModel;
  String? _cityName;
  int? _cityId = 1;
  int? _storeId;

  @override
  void initState() {
    super.initState();
    _openCloseStore = OpenCloseStore();
    _dbService = DBService();
    _ownerModel = Owner();

    if (prefs.firstStore == true) {
      Future.delayed(const Duration(microseconds: 3000)).then((value) {
        setTutorial();
        showTutorial();
      });
      prefs.firstStore = false;
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
                    "Registrar tiendas",
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
                                    "A continuación, se mostrará el tutorial para el registro de tiendas de la app Embajadores, se recomienda visualizarlo por completo la primera vez, pero puede omitirlo y verlo cuando lo desee tocando en el icono ",
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
                    "Registrar tienda",
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
                                text: " Seleccione Ciudad\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.store,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text: " Seleccione Tienda\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.supervised_user_circle_outlined,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Escriba la cantidad de usuarios en operación\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.notes,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Agregue detalles del cambio de estado o deje la nota por defecto.\n\n\n",
                              ),
                              TextSpan(
                                text:
                                    "Al registrar una tienda por primera vez esta queda registrada en estado de 'Abierta'. Estas tiendas quedan registradas de forma local para facilitar el registro en línea de apertura y cierre de la tienda. ",
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
        identify: "Target 2",
        keyTarget: keyAddChk,
        shape: ShapeLightFocus.RRect,
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Registrar tienda adicional",
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
                                    "Permite registrar tiendas adicionales por si requiere registrar varias tiendas evitando que se cierre la pantalla de registro.",
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
                    padding: const EdgeInsets.only(top: 40.0),
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
        identify: "Target 3",
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
                    "Registrar/Agregar tienda adicional",
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
                                    "Permite registrar tiendas adicionales por si requiere registrar varias tiendas evitando que se cierre la pantalla de registro.",
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
                                    "Si no tiene tiendas registradas, la pantalla de registro de tiendas se mostrará por defecto.",
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
            leading: GestureDetector(
              //key: keyLogo,
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Stack(
                  children: <Widget>[
                    NeumorphicIcon(
                      Icons.flag,
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
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NeumorphicText(
                  'Embajadores',
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                //color: Colors.pinkAccent,
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: FormBuilder(
                        key: _formKeyCard,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              color: Colors.blueGrey,
                              padding: const EdgeInsets.all(10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "Por favor registre las tiendas que tiene a su cargo, por defecto se establecerá el estado en Abierta.",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FutureBuilder<List<City>>(
                                future: _apiService.getCities(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<City>> snapshot) {
                                  return !snapshot.hasData
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : FormBuilderDropdown<City>(
                                          key: keyCity,
                                          name: 'city',
                                          //initialValue: _listCity.first,
                                          decoration: InputDecoration(
                                              labelText: 'Ciudad',
                                              prefixIcon: Icon(
                                                  Icons.location_city,
                                                  color: _colors
                                                      .iconsColor(context),
                                                  size: 18)),
                                          hint:
                                              const Text('Seleccionar ciudad'),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                context,
                                                errorText: 'Ciudad requerida')
                                          ]),
                                          items: snapshot.data!
                                              .map((city) =>
                                                  DropdownMenuItem<City>(
                                                      child: Text(city.nombre!),
                                                      value: city))
                                              .toList(),
                                          onTap: () {
                                            setState(() {
                                              _enableStore = false;
                                            });
                                          },
                                          onChanged: (city) {
                                            if (city != null) {
                                              setState(() {
                                                _cityId = city.id;
                                                _cityName = city.nombre;
                                                _enableStore = true;
                                              });
                                            }
                                          },
                                        );
                                }),
                            Visibility(
                              visible: _enableStore,
                              child: FutureBuilder<List<Stores>>(
                                  future:
                                      _apiService.getStoresFromCities(_cityId!),
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
                                                    color: _colors
                                                        .iconsColor(context),
                                                    size: 18)),
                                            hint: const Text(
                                                'Seleccionar tienda'),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.required(
                                                  context,
                                                  errorText: 'Tienda requerida')
                                            ]),
                                            items: snapshot.data!
                                                .map((stores) =>
                                                    DropdownMenuItem<Stores>(
                                                        value: stores,
                                                        child: Text(
                                                            stores.nombre!)))
                                                .toList(),
                                            onChanged: (stores) {
                                              if (stores != null) {
                                                setState(() {
                                                  _storeId = stores.id;
                                                  _storeName = stores.nombre;
                                                });
                                              }
                                            },
                                          );
                                  }),
                            ),
                            FormBuilderTextField(
                              name: 'users',
                              controller: _usersController,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText:
                                        'Usuarios en operación requeridos'),
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
                            const Divider(),
                            FormBuilderTextField(
                              controller: _notesController,
                              name: 'notes',
                              maxLines: 5,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                counterText:
                                    '${_notesController.text.split(' ').length} palabra(s)',
                                labelText: 'Notas: ',
                                hintText: ('No es un campo obligatorio'),
                                border: const OutlineInputBorder(),
                                hoverColor: _colors.iconsColor(context),
                              ),
                              onChanged: (value) {
                                _notes = value!;
                              },
                            ),
                            FormBuilderCheckbox(
                              key: keyAddChk,
                              name: 'add+',
                              activeColor: _colors.iconsColor(context),
                              title: const Text(
                                  'Registrar apertura de tienda adicional'),
                              onChanged: (value) {
                                setState(() => _checkboxVal = value!);
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
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
                    Navigator.pop(context, true);
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
                  tooltip: 'Registrar tienda',
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: Stack(
                      children: <Widget>[
                        NeumorphicIcon(
                          Icons.store,
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
                    saveAndValidate();
                  },
                ),
              ],
            ),
          ),
        ));
  }

  saveAndValidate() {
    if (_formKeyCard.currentState!.saveAndValidate()) {
      if (_notes == '') _notes = 'Sin comentarios';
      _ownerModel!.id = _storeId;
      _ownerModel!.store = _storeName;
      _ownerModel!.city = _cityName;
      _ownerModel!.notes = _notes;
      _ownerModel!.status = 'Abierta';
      _ownerModel!.time = DateTime.now().toString();

      print(_ownerModel!.id);
      print(_ownerModel!.store);
      print(_ownerModel!.city);
      print(_ownerModel!.status);
      print(_ownerModel!.time);

      _openCloseStore!.idTienda = _storeId;
      _openCloseStore!.tipo = 2;
      _openCloseStore!.usuariosOperacion = int.parse(_usersController.text);
      _openCloseStore!.observacion = _notes;
      _openCloseStore!.fechaApertura = DateTime.now().toString();
      _openCloseStore!.fechaCierre = DateTime.now().toString();

      print(_openCloseStore!.idTienda);
      print(_openCloseStore!.tipo);
      print(_openCloseStore!.usuariosOperacion);
      print(_openCloseStore!.fechaApertura);
      print(_openCloseStore!.fechaCierre);

      _dbService!.getOpenedStore(_ownerModel!.id!.toString()).then((value) {
        if (value.isEmpty) {
          _apiService.openCloseStore(_openCloseStore!).then((value) {
            if (value.status == true) {
              EasyLoading.showInfo(
                  'Realizada apertura en linea y registro local de $_storeName',
                  maskType: EasyLoadingMaskType.custom,
                  dismissOnTap: true);
              _dbService!.registryOwner(_ownerModel!).then((value) {
                if (_checkboxVal == true) {
                  _formKeyCard.currentState!.reset();
                  _usersController.clear();
                  _notesController.clear();
                  _checkboxVal = false;
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const HomePage(),
                    ),
                  );
                }
              });
            }
          });
        } else {
          EasyLoading.showInfo(
              'La tienda ya se encuentra registrada en su lista.',
              maskType: EasyLoadingMaskType.custom,
              dismissOnTap: true);
        }
      });
    }
  }
}
