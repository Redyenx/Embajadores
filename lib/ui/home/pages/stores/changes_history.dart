import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

APIService apiService = APIService();
CustomColors _colors = CustomColors();

class ChangesHistory extends StatelessWidget {
  const ChangesHistory({Key? key, required this.incidentId}) : super(key: key);
  final int incidentId;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
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
              Icons.history,
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NeumorphicText(
                'Historial de cambios',
                //key: keyWelcome,
                style: NeumorphicStyle(
                  color: _colors.iconsColor(context),
                  intensity: 0.7,
                  depth: 1.5,
                  shadowLightColor: _colors.shadowColor(context),
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 15,
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
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: FutureBuilder<List<Update>>(
                future: apiService.getIncidentUpdates(incidentId),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Update>> snapshot) {
                  return !snapshot.hasData
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          padding: const EdgeInsets.all(5.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return infoContainer(snapshot.data!, index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                }),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
            ],
          ),
        ),
      ),
    );
  }

  Container infoContainer(List<Update> listUpdate, int index) {
    var description = listUpdate[index].descripcion;
    var status = listUpdate[index].nombreEstado;
    var creationDate = DateFormat('dd MMM yyyy - hh:mm a')
        .format(listUpdate[index].fechaCreacion!);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text("Estado:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text(status ?? '', style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: <Widget>[
              const Text("Fecha:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text(creationDate, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
          const Divider(),
          const Text('Detalles:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const Divider(),
          Expanded(
            flex: 0,
            child: Text(
              description ?? '',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
