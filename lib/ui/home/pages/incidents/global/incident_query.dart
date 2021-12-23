import 'dart:core';
import 'dart:io';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/home/pages/incidents/global/filter_all_incident.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Alignment, Column, Row, Border;

class IncidentsQuery extends StatefulWidget {
  const IncidentsQuery({Key? key}) : super(key: key);

  @override
  _IncidentsQueryState createState() => _IncidentsQueryState();
}

class _IncidentsQueryState extends State<IncidentsQuery> {
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  late IncidentsDataSource _incidentsDataSource;
  final CustomColors _colors = CustomColors();
  DateTime dateTime = DateTime.now();
  List<Incident> _listIncidents = [];

  var keyHelp = GlobalKey();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<List<Incident>> getIncidentsByOwner() async {
    var data = Provider.of<APIService>(context).getIncidents!.data;
    _listIncidents = data!;
    _incidentsDataSource = IncidentsDataSource(_listIncidents);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: getIncidentsByOwner(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraint) {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: constraint.maxHeight, //- dataPagerHeight,
                              width: constraint.maxWidth,
                              child: SfDataGridTheme(
                                data: SfDataGridThemeData(
                                    headerColor: _colors.iconsColor(context),
                                    brightness: Theme.of(context).brightness,
                                    headerHoverColor: Colors.green),
                                child: SfDataGrid(
                                  key: _key,
                                  columnWidthMode: ColumnWidthMode.auto,
                                  source: _incidentsDataSource,
                                  columns: <GridColumn>[
                                    GridColumn(
                                        columnName: 'Id',
                                        maximumWidth: 50,
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text(
                                              'ID',
                                              overflow: TextOverflow.ellipsis,
                                            ))),
                                    GridColumn(
                                        columnName: 'Ciudad',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Ciudad'))),
                                    GridColumn(
                                        columnName: 'Tienda',
                                        width: 120,
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Tienda'))),
                                    GridColumn(
                                        columnName: 'Tipo',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Tipo'))),
                                    GridColumn(
                                        columnName: 'Apertura',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Apertura'))),
                                    GridColumn(
                                        columnName: 'Cierre',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Cierre'))),
                                    GridColumn(
                                        columnName: 'Estado',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Estado'))),
                                    GridColumn(
                                        columnName: 'Servicio',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Servicio'))),
                                    GridColumn(
                                        columnName: 'Usuarios',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Usuarios'))),
                                    GridColumn(
                                        columnName: 'Afectados',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Afectados'))),
                                    GridColumn(
                                        columnName: 'Masivo',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Masivo'))),
                                    GridColumn(
                                        columnName: 'Componentes',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Componentes'))),
                                    GridColumn(
                                        columnName: 'Reporta',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child: const Text('Reporta'))),
                                    GridColumn(
                                        columnName: 'Observaciones',
                                        label: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            alignment: Alignment.centerLeft,
                                            child:
                                                const Text('Observaciones'))),
                                  ],
                                  allowSorting: true,
                                  allowColumnsResizing: true,
                                  columnResizeMode: ColumnResizeMode.onResize,
                                  rowsPerPage: 10,
                                  rowHeight: 80,
                                  frozenColumnsCount: 1,
                                  tableSummaryRows: [
                                    GridTableSummaryRow(
                                        color: Colors.blueGrey,
                                        showSummaryInRow: true,
                                        title:
                                            '             Total de registros: {count}',
                                        columns: <GridSummaryColumn>[
                                          const GridSummaryColumn(
                                              name: 'count',
                                              columnName: 'ID',
                                              summaryType:
                                                  GridSummaryType.count),
                                        ],
                                        position:
                                            GridTableSummaryRowPosition.top),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : const SizedBox(
                      height: 500,
                      child: Center(child: CircularProgressIndicator()));
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDialFabWidget(
        secondaryIconsList: const [
          Icons.cleaning_services_rounded,
          Icons.filter_list_alt,
          Icons.share,
        ],
        secondaryIconsText: const [
          "Cancelar consulta",
          "Realizar consulta",
          "Compartir",
        ],
        secondaryIconsOnPress: [
          () => {
                EasyLoading.showInfo('Filtro cancelado',
                        maskType: EasyLoadingMaskType.custom,
                        duration: const Duration(milliseconds: 3000),
                        dismissOnTap: true)
                    .then((value) {
                  final request =
                      Provider.of<APIService>(context, listen: false);
                  setState(() {
                    request.setType = 1;
                    request.setFilter = '';
                  });
                })
              },
          () {
            final request = Provider.of<APIService>(context, listen: false);
            setState(() {
              request.setType = 1;
              request.setFilter = '';
            });
            Navigator.push(context, MaterialPageRoute<String>(
              builder: (BuildContext context) {
                return const FilterAllIncidents();
              },
            )).then((value) {
              if (value != null) {
                setState(() {
                  request.setFilter += value;
                  super.widget;
                });
              }
            });
          },
          () => {shareExcel()}
        ],
        secondaryBackgroundColor: Colors.blueGrey,
        secondaryForegroundColor: Colors.white,
        primaryBackgroundColor: Colors.orange,
        primaryForegroundColor: Colors.white,
      ),
    );
  }

  Future<void> shareExcel() async {
    final Workbook workbook = _key.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    //OpenFile.open(fileName);
    sendMailAndAttachment(fileName);
  }

  String formatTime(DateTime fecha) {
    return DateFormat('dd MMM yyyy - hh:mm a').format(fecha);
  }

  sendMailAndAttachment(String fileName) async {
    _startDate = DateTime(dateTime.year, dateTime.month, 1);
    _endDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999);
    final Email email = Email(
      body: 'Datos compilados por la aplicación embajadores. \n' +
          'Se adjunta archivo de Excel a este email. \n' +
          'Fecha inicial: ${formatTime(_startDate!)} \n' +
          'Fecha final: ${formatTime(_endDate!)} \n' +
          'Creado: ${formatTime(DateTime.now())}',
      subject: 'Consulta de datos Embajadores',
      //recipients: ['claroembajadores@gmail.com'],
      isHTML: true,
      attachmentPaths: [fileName],
    );

    await FlutterEmailSender.send(email);
  }
}

class IncidentsDataSource extends DataGridSource {
  IncidentsDataSource(this.listIncidents) {
    buildDataGridRow();
  }
  int rowsPerPage = 15;
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  List<Incident> listIncidents = <Incident>[];

  void buildDataGridRow() {
    dataGridRows = listIncidents.map<DataGridRow>((e) {
      final dateFormat = DateFormat('yyyy-MM-dd -- hh:mm a');
      String? replaceOpenTime;
      String? replaceCloseTime;
      String? userName = e.usuNombre! + e.usuApellidos!;
      var replaceMassive = e.incMasivo == 1 ? 'Si' : 'No';
      if (e.incFechaApertura != null) {
        replaceOpenTime = dateFormat.format(e.incFechaApertura!);
      } else {
        replaceOpenTime = 'No almacenada';
      }
      if (e.incFechaCierre != null) {
        replaceCloseTime = dateFormat.format(e.incFechaCierre!);
      } else {
        replaceCloseTime = 'No almacenada';
      }

      String? replaceTipo;
      switch (e.incTipo) {
        case 1:
          {
            replaceTipo = 'Incidente';
          }
          break;
        case 2:
          {
            replaceTipo = 'Apertura';
          }
          break;
        case 3:
          {
            replaceTipo = 'Cierre';
          }
          break;
      }

      return DataGridRow(cells: [
        DataGridCell<int>(
          columnName: 'Id',
          value: e.idIncidencia,
        ),
        DataGridCell<String>(columnName: 'Ciudad', value: e.ciuNombre),
        DataGridCell<String>(columnName: 'Tienda', value: e.tieNombre),
        DataGridCell<String>(columnName: 'Tipo', value: replaceTipo),
        DataGridCell<String>(columnName: 'Apertura', value: replaceOpenTime),
        DataGridCell<String>(columnName: 'Cierre', value: replaceCloseTime),
        DataGridCell<String>(columnName: 'Estado', value: e.ineNombre),
        DataGridCell<String>(columnName: 'Servicio', value: e.serNombre),
        DataGridCell<int>(
            columnName: 'Usuarios', value: e.incUsuariosOperacion),
        DataGridCell<int>(
            columnName: 'Afectados', value: e.incUsuariosAfectados),
        DataGridCell<String>(columnName: 'Masivo', value: replaceMassive),
        DataGridCell<String>(columnName: 'Componentes', value: e.componentes),
        DataGridCell<String>(columnName: 'Reporta', value: userName),
        DataGridCell<String>(
            columnName: 'Observaciones', value: e.observaciones),
      ]);
    }).toList(growable: false);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    print(summaryValue);
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      Color getColor() {
        if (e.columnName == 'Estado') {
          if (e.value == 'Cerrado') {
            return Colors.red[400]!;
          } else if (e.value == 'En curso') {
            return Colors.green[400]!;
          } else if (e.value == 'Pendiente') {
            return Colors.orange[400]!;
          }
        }

        return Colors.transparent;
      }

      return Container(
        color: getColor(),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(10.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
