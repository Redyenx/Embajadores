import 'package:embajadores/data/models/cities_stores.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FilterActiveIncidents extends StatefulWidget {
  const FilterActiveIncidents({Key? key}) : super(key: key);

  @override
  _FilterActiveIncidentsState createState() => _FilterActiveIncidentsState();
}

class _FilterActiveIncidentsState extends State<FilterActiveIncidents> {
  final CustomColors _colors = CustomColors();
  final APIService _apiService = APIService();
  final _listStatus = <String>[
    'En curso',
    'Pendiente',
  ];
  var cityId = 0;
  int? status;
  var massive = false;
  var fails = false;
  var filter = '';
  var fs = '%26%26';
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
                ],
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NeumorphicText(
                  'Consultar incidentes activos',
                  //key: keyWelcome,
                  style: NeumorphicStyle(
                    color: _colors.iconsColor(context),
                    intensity: 0.7,
                    depth: 1.5,
                    shadowLightColor: _colors.shadowColor(context),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: NeumorphicIcon(
                    Icons.help_outline,
                    //key: keyHelp,
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
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                FutureBuilder<List<City>>(
                    future: _apiService.getCities(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<City>> snapshot) {
                      return !snapshot.hasData
                          ? const Center(child: CircularProgressIndicator())
                          : FormBuilderDropdown<City>(
                              name: 'city',
                              //initialValue: _listCity.first,
                              decoration: InputDecoration(
                                  labelText: 'Ciudad',
                                  prefixIcon: Icon(Icons.location_city,
                                      color: _colors.iconsColor(context),
                                      size: 18)),
                              hint: const Text('Seleccionar ciudad'),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: 'Ciudad requerida')
                              ]),
                              items: snapshot.data!
                                  .map((city) => DropdownMenuItem<City>(
                                      child: Text(city.nombre!), value: city))
                                  .toList(),
                            );
                    }),
                FormBuilderDropdown(
                  name: 'status',
                  decoration: InputDecoration(
                      labelText: 'Estado',
                      prefixIcon: Icon(Icons.lock_open,
                          color: _colors.iconsColor(context), size: 18)),
                  hint: const Text('Seleccionar estado actual'),
                  items:
                      _listStatus.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    status = _listStatus.indexOf(value.toString());
                    print(status);
                  },
                ),
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
                            shadowLightColor: _colors.shadowColor(context),
                            depth: 1,
                            intensity: 0.7),
                      ),
                      const Text('Incidentes masivos'),
                      Switch(
                          activeColor: _colors.iconsColor(context),
                          value: massive,
                          onChanged: (value) {
                            setState(() {
                              massive = !massive;
                            });
                          }),
                    ],
                  ),
                ),
              ],
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
                  //key: keyCancel,
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
                  //key: keyCancel,
                  style: NeumorphicStyle(
                      color: _colors.contextColor(context),
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                      shadowLightColor: _colors.shadowColor(context),
                      depth: 2,
                      intensity: 1),
                  tooltip: 'Enviar actualización',
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.filter_list_alt,
                      color: _colors.iconsColor(context),
                      size: 30,
                    ),
                  ),
                  onPressed: () {
                    if (cityId > 0) filter += '${fs}id_ciudad=$cityId';
                    if (status != null) filter += '${fs}estado=$status';
                    if (massive == true) filter += '${fs}masivos=$massive';
                    Navigator.pop(context, filter);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
