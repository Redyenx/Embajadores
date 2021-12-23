import 'dart:convert';

import 'package:equatable/equatable.dart';

Assigned assignedFromJson(String str) => Assigned.fromJson(json.decode(str));

String assignedToJson(Assigned data) => json.encode(data.toJson());

class Assigned {
  Assigned({
    this.stores,
  });

  List<Store>? stores;

  factory Assigned.fromJson(Map<String, dynamic> json) => Assigned(
        stores: List<Store>.from(json["stores"].map((x) => Store.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stores": List<dynamic>.from(stores!.map((x) => x.toJson())),
      };
}

class Store {
  Store({
    this.city,
    this.name,
    this.users,
    this.status,
  });

  String? city;
  String? name;
  int? users;
  String? status;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        city: json["city"],
        name: json["name"],
        users: json["users"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "name": name,
        "users": users,
        "status": status,
      };
}

AffectedService affectedServiceFromJson(String str) =>
    AffectedService.fromJson(json.decode(str));

String affectedServiceToJson(AffectedService data) =>
    json.encode(data.toJson());

class AffectedService {
  AffectedService({
    this.service,
  });

  List<Service>? service;

  factory AffectedService.fromJson(Map<String, dynamic> json) =>
      AffectedService(
        service:
            List<Service>.from(json["service"].map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service": List<dynamic>.from(service!.map((x) => x.toJson())),
      };
}

class Service {
  Service(
      {this.name,
      this.type,
      this.component,
      this.city,
      this.store,
      this.users,
      this.affected,
      this.status,
      this.owner,
      this.creationDate,
      this.endDate});

  String? name;
  List<String>? type;
  List<String>? component;
  String? city;
  String? store;
  int? users;
  int? affected;
  String? status;
  String? owner;
  DateTime? creationDate;
  DateTime? endDate;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        name: json["name"],
        type: List<String>.from(json["type"].map((x) => x)),
        component: List<String>.from(json["component"].map((x) => x)),
        city: json["city"],
        store: json["store"],
        users: json["users"],
        affected: json["affected"],
        status: json["status"],
        owner: json["owner"],
        creationDate: DateTime.parse(json["creationDate"]),
        endDate: DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": List<dynamic>.from(type!.map((x) => x)),
        "component": List<dynamic>.from(component!.map((x) => x)),
        "city": city,
        "store": store,
        "users": users,
        "affected": affected,
        "status": status,
        "owner": owner,
        "creationDate": creationDate,
        "endDate": endDate,
      };
}

ListService serviceListFromJson(String str) =>
    ListService.fromJson(json.decode(str));

String serviceListToJson(ListService data) => json.encode(data.toJson());

class ListService {
  ListService({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<ServiceInfo>? data;

  factory ListService.fromJson(Map<String, dynamic> json) => ListService(
        status: json["status"],
        message: json["message"],
        data: List<ServiceInfo>.from(
            json["data"].map((x) => ServiceInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ServiceInfo extends Equatable {
  ServiceInfo({
    this.id,
    this.nombre,
  });

  int? id;
  String? nombre;

  @override
  List<Object> get props => [id!, nombre!];

  factory ServiceInfo.fromJson(Map<String, dynamic> json) => ServiceInfo(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}

ServiceComponents serviceComponentsFromJson(String str) =>
    ServiceComponents.fromJson(json.decode(str));

String serviceComponentsToJson(ServiceComponents data) =>
    json.encode(data.toJson());

class ServiceComponents {
  ServiceComponents({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Component>? data;

  factory ServiceComponents.fromJson(Map<String, dynamic> json) =>
      ServiceComponents(
        status: json["status"],
        message: json["message"],
        data: List<Component>.from(
            json["data"].map((x) => Component.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Component extends Equatable {
  Component({
    this.id,
    this.nombre,
  });

  int? id;
  String? nombre;

  @override
  List<Object> get props => [id!, nombre!];

  factory Component.fromJson(Map<String, dynamic> json) => Component(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}
