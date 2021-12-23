import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/models/report_basic.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:darq/darq.dart';

class IncidentReport extends StatefulWidget {
  const IncidentReport({Key? key, required this.listIncidents})
      : super(key: key);
  final List<Incident> listIncidents;
  @override
  _IncidentReportState createState() => _IncidentReportState();
}

class _IncidentReportState extends State<IncidentReport> {
  final CustomColors _colors = CustomColors();
  List<Incident> listIncidents = [];
  var openedStore = 0;
  var closedStore = 0;
  var massive = 0;
  var incidents = 0;
  var totalIncidents = 0;
  List<Report> listReport = <Report>[];
  Report report = Report();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listIncidents = widget.listIncidents;
    getData();
  }
/*

  void getDataX() {
    var result = listIncidents
        .groupBy((e) => e.serNombre)
        .distinct()
        .select((e, index) => Report(serviceName: e));
    print(result);
  }
*/

  void getData() {
    Iterable<String> services =
        listIncidents.select((e, index) => e.serNombre!).distinct();

    for (String service in services) {
      report.serviceName = service;
      report.users = listIncidents
          .where((i) => i.serNombre == service)
          .sum((i) => i.incUsuariosOperacion!);
      report.affectedUsers = listIncidents
          .where((i) => i.serNombre == service)
          .sum((i) => i.incUsuariosAfectados!);
      report.affectedStores =
          listIncidents.where((i) => i.serNombre == service).count();
      //print(report.serviceName);

      listReport.add(report);
    }

/*    services.forEach((e) {
      report.serviceName = e;
      report.users = listIncidents
          .where((i) => i.serNombre == e)
          .sum((i) => i.incUsuariosOperacion!);
      report.affectedUsers = listIncidents
          .where((i) => i.serNombre == e)
          .sum((i) => i.incUsuariosAfectados!);
      report.affectedStores =
          listIncidents.where((i) => i.serNombre == e).count();
      //print(report.serviceName);

      listReport.add(report);

      var dat =
          listIncidents.select((x, index) => {x.incUsuariosOperacion, index}).where((element) => element.);
      print(dat);
    });*/
/*    print(listReport[0].serviceName);
    print(listReport[0].affectedStores);
    print(listReport[0].users);
    print(listReport[0].affectedUsers);
    print(listReport[1].serviceName);
    print(listReport[1].affectedStores);
    print(listReport[1].users);
    print(listReport[1].affectedUsers);*/
//var aa = listIncidents.select((element, index) => element.incUsuariosOperacion).where((element) => element)
/*    var data = listIncidents
        .select((e, index) => e.incUsuariosOperacion!)
        .where((e) => e == 1)
        .sum((x) => x);
    print(data);
    services.forEach((element) {
      print(element);
    });*/
/*    services.forEach((e) {
      report.serviceName = e;
      report.affectedStores = listIncidents.count((i) => i.serNombre == e);
      var users = listIncidents.select((i, index) => e);
      //var totalSum = users.sum();
      //var
      var affectedUsers =
          listIncidents.select((e, index) => e.incUsuariosAfectados!);
      var sum = affectedUsers.sum((x) => x);
*/ /*      print(affectedUsers);
      print(sum);
      print(users);*/ /*
      //print(totalSum);
      listReport.add(report);
    });*/

/*    listReport.forEach((e) {
      print(e.serviceName);
      print(e.affectedStores);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(120.0),
          border: TableBorder.all(
              color: _colors.borderColor(context),
              style: BorderStyle.solid,
              width: 1),
          children: [
            _tableRow('Tiendas', 'Cantidad', 15),
            _tableRow('Abiertas', openedStore.toString(), 12),
            _tableRow('Cerradas', closedStore.toString(), 12),
            _tableRow('Masivos', massive.toString(), 12),
            _tableRow('Afectadas', incidents.toString(), 12),
            _tableRow('Incidentes', totalIncidents.toString(), 12),
          ],
        ),
      ),
    );
  }

  TableRow _tableRow(String description, String quantity, double fontSize) {
    return TableRow(children: [
      Column(children: [
        Text(
          description,
          style:
              TextStyle(color: _colors.textColor(context), fontSize: fontSize),
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
}
