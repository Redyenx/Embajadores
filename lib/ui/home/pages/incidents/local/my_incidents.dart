import 'dart:convert';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:embajadores/data/controllers/themenotifier.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/models/owner.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/data/services/db_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:embajadores/ui/home/pages/incidents/global/incident_details.dart';
import 'package:embajadores/ui/home/pages/incidents/local/register_incident.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MyIncidents extends StatefulWidget {
  const MyIncidents({
    Key? key,
  }) : super(key: key);

  //final
  @override
  _MyIncidentsState createState() => _MyIncidentsState();
}

class _MyIncidentsState extends State<MyIncidents> {
  final CustomColors _colors = CustomColors();
  APIService apiService = APIService();
  final prefs = UserPreferences();
  List<TargetFocus> targets = [];
  String? jsonCategories;
  int? requirementStatus;
  int keyCount = 0;

  Future<List<Incident>> getIncidentsByOwner(String filter) async {
    final counter = Provider.of<CounterProvider>(context, listen: false);
    var data = apiService.getUserIncidents(filter);
    await data.then((value) {
      prefs.ownerCount = value.length;
      counter.onChange(value.length);
    });
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Incident>>(
            future: getIncidentsByOwner('%26%26id_usuario=${prefs.userId}'),
            builder:
                (BuildContext context, AsyncSnapshot<List<Incident>> snapshot) {
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
                                  return _registeredIncidentCard(
                                      context, snapshot.data!, index);
                                }),
                          ],
                        ),
                      ),
                    );
            }),
      ),
    );
  }

  Widget _registeredIncidentCard(
      BuildContext context, List<Incident> incidentDetails, int index) {
    var serviceName = incidentDetails[index].serNombre.toString();
    var serviceCity = incidentDetails[index].ciuNombre.toString();
    var serviceType = incidentDetails[index].tpfNombre.toString();
    var serviceComponent = incidentDetails[index].componentes.toString();
    var serviceStore = incidentDetails[index].tieNombre.toString();
    var serviceUsers = incidentDetails[index].incUsuariosOperacion.toString();
    var serviceAffected =
        incidentDetails[index].incUsuariosAfectados.toString();
    var serviceStatusId = incidentDetails[index].idEstado;
    var serviceStatus = incidentDetails[index].ineNombre.toString();
    var serviceOwner = incidentDetails[index].serNombre.toString();
    var creationDate = incidentDetails[index].incFechaApertura;
    var serviceComments = incidentDetails[index].incObservacion;
    var endDate = incidentDetails[index].incFechaCierre;
    final now = DateTime.now();
    final difference = now.difference(creationDate!);
    final fifteenAgo = DateTime.now().subtract(difference);
    bool _expanded = false;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: ExpansionTileCard(
        onExpansionChanged: (value) => _expanded = value,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NeumorphicIcon(
              Icons.warning_amber,
              size: 40,
              style: NeumorphicStyle(
                  color: serviceStatusId == 1
                      ? Colors.redAccent
                      : Colors.orangeAccent,
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: Colors.redAccent,
                  depth: 1,
                  intensity: 0.7),
            ),
            Text(
              serviceStatus,
              style: const TextStyle(fontSize: 8),
            ),
          ],
        ),
        title: Container(
          width: 200,
          height: 80,
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
                    ' $serviceName',
                    maxLines: 1,
                    minFontSize: 6,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.store,
                    color: _colors.iconsColor(context),
                    size: 15,
                  ),
                  AutoSizeText(
                    ' $serviceStore',
                    maxLines: 2,
                    minFontSize: 7,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.supervised_user_circle_outlined,
                    color: _colors.iconsColor(context),
                    size: 15,
                  ),
                  Text(
                    ' Usuarios: $serviceUsers',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.error,
                    color: _colors.iconsColor(context),
                    size: 15,
                  ),
                  Text(
                    ' Afectados: $serviceAffected',
                    style: TextStyle(
                      color: serviceAffected == '0'
                          ? Colors.red
                          : Colors.orangeAccent,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: _colors.iconsColor(context),
                    size: 15,
                  ),
                  Text(
                    ' ' + timeago.format(fifteenAgo, locale: 'es'),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 60,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<bool>(
                                builder: (context) => IncidentDetailsUpdate(
                                      incident: incidentDetails[index],
                                      expanded: _expanded,
                                    ))).then((value) {
                          if (value == true) {
                            setState(() => super.widget);
                          }
                        });
                      },
                      child: NeumorphicIcon(
                        Icons.app_registration,
                        size: 40,
                        style: NeumorphicStyle(
                            color: Colors.red,
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(10)),
                            shadowLightColor: Colors.redAccent,
                            depth: 1,
                            intensity: 0.7),
                      )),
                ],
              ),
            ),
          ],
        ),
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.comment,
                      color: _colors.iconsColor(context),
                      size: 15,
                    ),
                    const Text(
                      ' Detalles',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                AutoSizeText(
                  serviceComments!,
                  maxLines: 3,
                  minFontSize: 4,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: _colors.textColor(context)),
                  overflowReplacement:
                      const Text('La descripción es muy extensa'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
