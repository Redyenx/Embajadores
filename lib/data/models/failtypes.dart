import 'dart:convert';

import 'package:equatable/equatable.dart';

ListOfFailType listOfFailTypeFromJson(String str) =>
    ListOfFailType.fromJson(json.decode(str));

String listOfFailTypeToJson(ListOfFailType data) => json.encode(data.toJson());

class ListOfFailType {
  ListOfFailType({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<FailTypes>? data;

  factory ListOfFailType.fromJson(Map<String, dynamic> json) => ListOfFailType(
        status: json["status"] ?? 0,
        message: json["message"] ?? "",
        data: List<FailTypes>.from(
            json["data"].map((x) => FailTypes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status ?? 0,
        "message": message ?? "",
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FailTypes extends Equatable {
  const FailTypes({
    this.id,
    this.nombre,
  });

  final int? id;
  final String? nombre;

  @override
  List<Object> get props => [id!, nombre!];

  factory FailTypes.fromJson(Map<String, dynamic> json) => FailTypes(
        id: json["id"] ?? 0,
        nombre: json["nombre"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}

ListServiceStatus listServiceStatusFromJson(String str) =>
    ListServiceStatus.fromJson(json.decode(str));

String listServiceStatusToJson(ListServiceStatus data) =>
    json.encode(data.toJson());

class ListServiceStatus {
  ListServiceStatus({
    this.status,
    this.message,
    this.data,
  });

  final bool? status;
  final String? message;
  final List<ServiceStatus>? data;

  factory ListServiceStatus.fromJson(Map<String, dynamic> json) =>
      ListServiceStatus(
        status: json["status"] ?? 0,
        message: json["message"] ?? "",
        data: List<ServiceStatus>.from(
            json["data"].map((x) => ServiceStatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status ?? 0,
        "message": message ?? "",
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ServiceStatus extends Equatable {
  const ServiceStatus({
    this.id,
    this.nombre,
  });

  final int? id;
  final String? nombre;

  @override
  List<Object> get props => [id!, nombre!];

  factory ServiceStatus.fromJson(Map<String, dynamic> json) => ServiceStatus(
        id: json["id"] ?? 0,
        nombre: json["nombre"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}
