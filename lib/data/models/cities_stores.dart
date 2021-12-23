import 'dart:convert';
import 'package:equatable/equatable.dart';

ListOfCities listOfCitiesFromJson(String str) =>
    ListOfCities.fromJson(json.decode(str));

String listOfCitiesToJson(ListOfCities data) => json.encode(data.toJson());

class ListOfCities {
  ListOfCities({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<City>? data;

  factory ListOfCities.fromJson(Map<String, dynamic> json) => ListOfCities(
        status: json["status"],
        message: json["message"],
        data: List<City>.from(json["data"].map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class City extends Equatable {
  City({
    this.id,
    this.nombre,
  });

  final int? id;
  final String? nombre;

  @override
  List<Object> get props => [id!, nombre!];

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}

ListOfStores listOfStoresFromJson(String str) =>
    ListOfStores.fromJson(json.decode(str));

String listOfStoresToJson(ListOfStores data) => json.encode(data.toJson());

class ListOfStores {
  ListOfStores({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Stores>? data;

  factory ListOfStores.fromJson(Map<String, dynamic> json) => ListOfStores(
        status: json["status"] == null ? false : json["status"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null
            ? null
            : List<Stores>.from(json["data"].map((x) => Stores.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Stores extends Equatable {
  Stores({
    this.id,
    this.nombre,
    this.estado,
    this.descEstado,
  });

  final int? id;
  final String? nombre;
  final int? estado;
  final String? descEstado;

  @override
  List<Object> get props => [id!, nombre!, estado!, descEstado!];

  factory Stores.fromJson(Map<String, dynamic> json) => Stores(
        id: json["id"] == null ? 0 : json["id"],
        nombre: json["nombre"] == null ? "" : json["nombre"],
        estado: json["estado"] == null ? 0 : json["estado"],
        descEstado: json["desc_estado"] == null ? "" : json["desc_estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "nombre": nombre == null ? null : nombre,
        "estado": estado == null ? null : estado,
        "desc_estado": descEstado == null ? null : descEstado,
      };
}

Services servicesFromJson(String str) => Services.fromJson(json.decode(str));

String servicesToJson(Services data) => json.encode(data.toJson());

class Services {
  Services({
    this.services,
  });

  List<String>? services;

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        services: List<String>.from(json["services"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "services": List<dynamic>.from(services!.map((x) => x)),
      };
}

List<CityStores> cityStoresFromJson(String str) =>
    List<CityStores>.from(json.decode(str).map((x) => CityStores.fromJson(x)));

String cityStoresToJson(List<CityStores> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityStores {
  CityStores({
    this.city,
    this.stores,
  });

  String? city;
  List<String>? stores;

  factory CityStores.fromJson(Map<String, dynamic> json) => CityStores(
        city: json["city"],
        stores: List<String>.from(json["stores"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "stores": List<dynamic>.from(stores!.map((x) => x)),
      };
}
