import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:badges/badges.dart';
import 'package:embajadores/data/controllers/formhelper.dart';
import 'package:embajadores/data/models/assigned.dart';
import 'package:embajadores/data/models/failtypes.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:embajadores/ui/home/pages/stores/changes_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class IncidentDetailsUpdate extends StatefulWidget {
  const IncidentDetailsUpdate(
      {Key? key, required this.incident, required this.expanded})
      : super(key: key);
  final Incident? incident;
  final bool? expanded;
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<IncidentDetailsUpdate> {
  final _affectedUsersController = TextEditingController();
  final _formKeyCard = GlobalKey<FormBuilderState>();
  final _notesController = TextEditingController();
  final CustomColors _colors = CustomColors();
  APIService apiService = APIService();
  String _ultimaFecha = 'sin ingreso';
  UpdateIncident? _updateIncident;
  final prefs = UserPreferences();
  List<TargetFocus> targets = [];
  var keyCancel = GlobalKey();
  var keyAddChk = GlobalKey();
  var keyHelp = GlobalKey();
  var keySave = GlobalKey();
  int? _selectedStatus;
  int _affected = 0;
  String? _notes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedStatus = widget.incident!.idEstado;
    _updateIncident = UpdateIncident();
    if (prefs.firstViewOrEdit == true) {
      Future.delayed(const Duration(microseconds: 3000)).then((value) {
        setTutorial();
        showTutorial();
      });
      prefs.firstViewOrEdit = false;
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
                                    "A continuación, se mostrará el tutorial de actualización de incidentes, que describirá a detalle como se debe actualizar la información del incidente registrado. Se recomienda leerlo por completo la primera vez, pero puede omitirlo y verlo cuando lo desee tocando en el icono ",
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
                    "Actualizar incidente",
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
                                Icons.refresh,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Visualizar historial de cambios: Expanda los detalles seleccionando el ID del incidente y presione el botón 'Historial de cambios'\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.check_box_outlined,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text: " Seleccione nuevo estado actual (*)\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.notes,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " Reporte las novedades presentadas del incidente actual (Campo obligatorio)\n",
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
                              TextSpan(
                                text:
                                    "(*) Estados de incidente (Seleccione):\nPendiente: Si el incidente actual está registrado como pendiente, se habilitará el campo de usuarios afectados y deberá poder actualizar esta información. No podrá actualizar el incidente si este campo está en blanco.\nEn curso: Si el incidente sigue actualmente en curso y no ha sido solucionado.\nCerrado: Seleccione esta opción solo sí el incidente reportado ya fue solucionado.",
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
                    "Actualizar incidente",
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
                                    "Registra la actualización diligenciada en línea.",
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
                                    "Cancela la operación de actualización de incidente actual.",
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
    _ultimaFecha = DateFormat('dd MMM yyyy - hh:mm a')
        .format(widget.incident!.incFechaApertura!);
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
            child: NeumorphicIcon(
              Icons.update,
              size: 50,
              style: NeumorphicStyle(
                  color: _colors.iconsColor(context),
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: _colors.shadowColor(context),
                  depth: 1.5,
                  intensity: 0.7),
            ),
          ),
          title: AutoSizeText(
            'Actualizar incidente: '
            '${widget.incident!.ineNombre}',
            maxLines: 1,
            minFontSize: 8,
            style: TextStyle(
                color: _colors.textColor(context),
                fontWeight: FontWeight.bold,
                fontSize: 16),
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
          physics: const ScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 100.0),
            child: Wrap(children: <Widget>[
              FormBuilder(
                key: _formKeyCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    infoContainer(Icons.miscellaneous_services,
                        'Servicio afectado:', widget.incident!.serNombre!),
                    infoContainer(Icons.store, 'Tienda:',
                        '${widget.incident!.tieNombre}'),
                    ExpansionTile(
                      initiallyExpanded: widget.expanded!,
                      title: Text(
                        'ID incidente: ${widget.incident!.idIncidencia}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            infoContainer(
                                Icons.featured_play_list, 'Componentes:', ''),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AutoSizeText(
                                widget.incident!.componentes!,
                                maxLines: 10,
                                minFontSize: 4,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _colors.textColor(context)),
                              ),
                            ),
                            infoContainer(Icons.location_city, 'Ciudad:',
                                widget.incident!.ciuNombre!),
                            infoContainer(
                                Icons.date_range, 'Registrado:', _ultimaFecha),
                            infoContainer(Icons.support_agent, 'Registra:',
                                '${widget.incident!.usuNombre}${widget.incident!.usuApellidos}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                infoContainer(
                                    Icons.supervised_user_circle_outlined,
                                    'Usuarios:',
                                    widget.incident!.incUsuariosOperacion
                                        .toString()),
                                infoContainer(
                                    Icons.help_outline_outlined,
                                    'Afectados:',
                                    widget.incident!.incUsuariosAfectados
                                        .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                infoContainer(Icons.circle, 'Estado:',
                                    '${widget.incident!.ineNombre}'),
                                infoContainer(
                                    Icons.error_outline,
                                    'Masivo:',
                                    widget.incident!.incMasivo == 1
                                        ? 'Si'
                                        : 'No'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                infoContainer(Icons.message, 'Detalles:', ''),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: NeumorphicButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangesHistory(
                                                    incidentId: widget.incident!
                                                        .idIncidencia!,
                                                  )));
                                    },
                                    tooltip: 'Historial de cambios',
                                    style: NeumorphicStyle(
                                        color: _colors.contextColor(context),
                                        shape: NeumorphicShape.flat,
                                        boxShape:
                                            const NeumorphicBoxShape.rect(),
                                        shadowLightColor:
                                            _colors.shadowColor(context),
                                        depth: 0.3,
                                        intensity: 0.7),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.refresh,
                                          color: _colors.iconsColor(context),
                                          size: 20,
                                        ),
                                        const Text(
                                          ' Historial de cambios',
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AutoSizeText(
                                '${widget.incident!.incObservacion}',
                                textAlign: TextAlign.justify,
                                minFontSize: 4,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Visibility(
                      visible: _selectedStatus == 1,
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
                          FormBuilderValidators.max(
                              context, widget.incident!.incUsuariosOperacion!,
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
                            print(_affected);
                          }
                        },
                      ),
                    ),
                    FutureBuilder<List<ServiceStatus>>(
                        future: apiService.getServiceStatus(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ServiceStatus>> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return FormBuilderDropdown<ServiceStatus>(
                              name: 'actualStatus',
                              //initialValue: snapshot.data!.last,
                              decoration: const InputDecoration(
                                  labelText: 'Actualizar estado actual a'),
                              hint:
                                  const Text('Seleccionar nuevo estado actual'),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: 'Estado actual requerido')
                              ]),
                              items: snapshot.data!
                                  .map((serviceStatus) =>
                                      DropdownMenuItem<ServiceStatus>(
                                          child: Text(serviceStatus.nombre!),
                                          value: serviceStatus))
                                  .toList(),
                              onChanged: (serviceStatus) {
                                _selectedStatus = serviceStatus!.id;

                                print(_selectedStatus);
                              },
                            );
                          }
                        }),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'Notas adicionales: ',
                        style: TextStyle(
                            color: _colors.textColor(context), fontSize: 14),
                      ),
                    ),
                    FormBuilderTextField(
                        name: 'notes',
                        controller: _notesController,
                        maxLines: 5,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText:
                                  'Se requiere una descripción de la actualización')
                        ]),
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          counterText:
                              '${_notesController.text.split(' ').length} palabra(s)',
                          labelText: 'Nota de actualización (Obligatorio)',
                          hintText: ('Obligatorio...'),
                          border: const OutlineInputBorder(),
                          hoverColor: _colors.iconsColor(context),
                        ),
                        onChanged: (value) => setState(() => _notes = value!)),
                    FormBuilderCheckbox(
                      name: 'ensure',
                      activeColor: _colors.iconsColor(context),
                      title:
                          const Text("Toda la información ingresada es válida"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText:
                                "Debe certificar que toda la información ingresada es válida")
                      ]),
                    ),
                  ],
                ),
              ),
            ]),
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
                tooltip: 'Enviar actualización',
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.system_update_alt,
                    color: _colors.iconsColor(context),
                    size: 30,
                  ),
                ),
                onPressed: () {
                  saveAndValidate();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container infoContainer(IconData icon, String label, String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 10.0),
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

  void saveAndValidate() {
    if (_formKeyCard.currentState!.saveAndValidate()) {
      _updateIncident!.idEstado = _selectedStatus;
      _updateIncident!.usuariosAfectados = _affected;
      _updateIncident!.descripcion = _notes;

      print(_updateIncident!.idEstado);
      print(_updateIncident!.usuariosAfectados);
      print(_updateIncident!.descripcion);

      apiService
          .updateIncident(_updateIncident!, widget.incident!.idIncidencia!)
          .then((value) {
        if (value.status == true) {
          EasyLoading.showInfo('Incidente actualizado correctamente',
              maskType: EasyLoadingMaskType.custom,
              duration: const Duration(milliseconds: 5000),
              dismissOnTap: true);
          Navigator.pop(context, true);
        }
      });
    }
  }
}
