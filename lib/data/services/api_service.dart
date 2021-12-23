import 'dart:convert';
import 'package:embajadores/data/models/assigned.dart';
import 'package:embajadores/data/models/cities_stores.dart';
import 'package:embajadores/data/models/failtypes.dart';
import 'package:embajadores/data/models/global_stores.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/models/login_model.dart';
import 'package:embajadores/data/models/response.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://pointdesk.asicamericas.com:9002/api';
var dateTime = DateTime.now();

class APIService with ChangeNotifier {
  List<Incident>? listIncidents;
  final prefs = UserPreferences();
  GetIncidents? getIncidents;
  var _isLoading = true;
  var _setFilter = '';
  int? _setType;

  APIService() {
    if (prefs.userId != '0') {
      getAllIncidents(_setFilter);
      getUserIncidents(prefs.userId);
    }
    print('Api iniciada...');
  }

  bool get isLoading => _isLoading;

  String get setFilter => _setFilter;

  int get setType {
    return _setType!;
  }

  set setType(int value) {
    _setType = value;
  }

  set setFilter(String value) {
    _setFilter = value;
    _isLoading = true;
    getAllIncidents(value);
    notifyListeners();
  }

  Future<List<City>>? getCities() async {
    print('Obteniendo ciudades...');
    String? url = '$baseUrl/cities';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });
    var cities = ListOfCities.fromJson(json.decode(response.body)).data;
    notifyListeners();
    return cities!;
  }

  Future<List<StoreData>> getAllStoresData(String filter) async {
    print('Obteniendo lista global de tiendas...');
    String? url = '$baseUrl/stores?$filter';
    print('Url tiendas: $url');
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });
    var stores = AllStoresData.fromJson(json.decode(response.body)).data;
    notifyListeners();
    return stores!;
  }

  Future<void> getAllIncidents(String filter) async {
    String? url;
    if (filter == '') {
      DateTime dateTime = DateTime.now();
      DateTime? _startDate;
      DateTime? _endDate;
      _startDate = DateTime(dateTime.year, dateTime.month, 1);
      _endDate = DateTime.now();

      print('Obteniendo lista global de incidentes...');
      url = '$baseUrl/incidences?filters=inc_tipo=1'
          '%26%26inc_fecha_apertura>="$_startDate"'
          '%26%26inc_fecha_apertura<="$_endDate"';
    } else {
      url = '$baseUrl/incidences?filters=$filter';
    }

    print('Url: $url');
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });
    getIncidents = GetIncidents.fromJson(json.decode(response.body));
    notifyListeners();
  }

  Future<List<Incident>> getUserIncidents(String filter) async {
    String? url;
    url = '$baseUrl/incidences?filters=inc_tipo=1%26%26id_estado!=3$filter';

    print('Filtro actual: $filter');
    print('Obteniendo lista de incidentes activos...');

    print('Url: $url');
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });
    print(response.body);
    listIncidents = GetIncidents.fromJson(json.decode(response.body)).data;
    notifyListeners();
    return listIncidents!;
  }

  Future<List<String>>? getListCities() async {
    print('Obteniendo ciudades...');
    List<String> listCities = [];
    String? url = '$baseUrl/cities';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });
    var cities = ListOfCities.fromJson(json.decode(response.body)).data;

    for (var city in cities!) {
      listCities.add(city.nombre!);
    }
    return listCities;
  }

  Future<List<Stores>>? getStoresFromCities(int id) async {
    if (id == 0) id = 1;
    print('Obteniendo tiendas...');
    String? url = '$baseUrl/cities/$id/stores?estado=0';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });

    var stores = ListOfStores.fromJson(json.decode(response.body)).data;
    notifyListeners();
    return stores!;
  }

  Future<List<ServiceInfo>>? getServices() async {
    print('Obteniendo lista de servicios...');
    String? url = '$baseUrl/services';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });

    List<ServiceInfo> services =
        ListService.fromJson(json.decode(response.body)).data!;
    notifyListeners();
    return services;
  }

  Future<List<Component>>? getComponents(int service) async {
    print('Obteniendo lista de componentes del servicio...');
    String? url = '$baseUrl/services/$service/components';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });
    List<Component> components =
        ServiceComponents.fromJson(json.decode(response.body)).data!;
    notifyListeners();
    return components;
  }

  Future<List<FailTypes>>? getFailTypes() async {
    print('Obteniendo descripción de fallas...');
    String? url = '$baseUrl/failures';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });
    List<FailTypes> fails =
        ListOfFailType.fromJson(json.decode(response.body)).data!;
    notifyListeners();
    return fails;
  }

  Future<List<ServiceStatus>> getServiceStatus() async {
    print('Obteniendo estados del servicio...');
    String? url = '$baseUrl/incidences/states';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });
    List<ServiceStatus> serviceStatus =
        ListServiceStatus.fromJson(json.decode(response.body)).data!;
    notifyListeners();
    return serviceStatus;
  }

  Future<ResponseStatus> registerIncident(reportIncident) async {
    print('Registrando incidente...');
    String? url = '$baseUrl/incidences';
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${prefs.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(reportIncident.toJson()));
    if (response.statusCode == 201 || response.statusCode == 400) {
      notifyListeners();
      return ResponseStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('No se pudieron enviar los datos');
    }
  }

  Future<ResponseStatus> updateIncident(
      UpdateIncident updateIncident, int incidentId) async {
    print('Actualizando incidente : $incidentId...');
    String? url = '$baseUrl/incidences/$incidentId/observations';
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${prefs.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateIncident.toJson()));
    if (response.statusCode == 201 || response.statusCode == 400) {
      notifyListeners();
      return ResponseStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('No se pudieron enviar los datos');
    }
  }

  Future<List<Update>> getIncidentUpdates(int incidentId) async {
    print('Obteniendo actualizaciones de incidente...$incidentId');
    String? url = '$baseUrl/incidences/$incidentId/observations';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${prefs.token}',
    });
    List<Update> updates =
        GetUpdates.fromJson(json.decode(response.body)).data!;
    return updates;
  }

  Future<ResponseStatus> openCloseStore(OpenCloseStore openCloseStore) async {
    print('Cambiando estado de la tienda...');
    String? url = '$baseUrl/incidences';
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${prefs.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(openCloseStore.toJson()));
    print(openCloseStore.toJson());
    if (response.statusCode == 201 || response.statusCode == 400) {
      notifyListeners();
      return ResponseStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('No se pudieron cargar los datos');
    }
  }

  Future<LoginResponse> login(String username, String password) async {
    print('Iniciando sesión...');
    String? url = '$baseUrl/users/auth';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.post(Uri.parse(url), headers: <String, String>{
      'Authorization': basicAuth,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200 || response.statusCode == 401) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('No se pudieron cargar los datos');
    }
  }
}
