import 'dart:convert';

import 'package:equatable/equatable.dart';

AllStoresData listOfStoresFromJson(String str) =>
    AllStoresData.fromJson(json.decode(str));

String listOfStoresToJson(AllStoresData data) => json.encode(data.toJson());

class AllStoresData {
  AllStoresData({
    this.status,
    this.message,
    this.data,
  });

  final bool? status;
  final String? message;
  final List<StoreData>? data;

  factory AllStoresData.fromJson(Map<String, dynamic> json) => AllStoresData(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? null
            : List<StoreData>.from(
                json["data"].map((x) => StoreData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status ?? 0,
        "message": message ?? "",
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class StoreData extends Equatable {
  const StoreData({
    this.id,
    this.nombre,
    this.estado,
    this.descEstado,
    this.ciudad,
    this.usuario,
    this.incidentes,
  });

  final int? id;
  final String? nombre;
  final int? estado;
  final String? descEstado;
  final Ciudad? ciudad;
  final Usuario? usuario;
  final Incidentes? incidentes;

  @override
  List<Object> get props => [id!, nombre!, estado!, descEstado!];

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
        id: json["id"] ?? 0,
        nombre: json["nombre"] ?? "",
        estado: json["estado"] ?? 0,
        descEstado: json["desc_estado"] ?? "",
        ciudad: json["ciudad"] == null ? null : Ciudad.fromJson(json["ciudad"]),
        usuario:
            json["usuario"] == null ? null : Usuario.fromJson(json["usuario"]),
        incidentes: json["incidencias"] == null
            ? null
            : Incidentes.fromJson(json["incidencias"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "nombre": nombre ?? "",
        "estado": estado ?? 0,
        "desc_estado": descEstado ?? "",
        "ciudad": ciudad == null ? "" : ciudad!.toJson(),
        "usuario": usuario == null ? "" : usuario!.toJson(),
        "incidencias": incidentes == null ? null : incidentes!.toJson(),
      };
}

class Ciudad {
  Ciudad({
    this.id,
    this.nombre,
  });

  final int? id;
  final String? nombre;

  factory Ciudad.fromJson(Map<String, dynamic> json) => Ciudad(
        id: json["id"] ?? 0,
        nombre: json["nombre"] ?? "Sin asignar",
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "nombre": nombre ?? "",
      };
}

class Incidentes {
  Incidentes({
    this.serviciosCaidos,
    this.masivo,
    this.ultimaObservacion,
  });

  final int? serviciosCaidos;
  final bool? masivo;
  final String? ultimaObservacion;

  factory Incidentes.fromJson(Map<String, dynamic> json) => Incidentes(
        serviciosCaidos: json["servicios_caidos"] ?? 0,
        masivo: json["masivo"] ?? false,
        ultimaObservacion: json["ultima_observacion"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "servicios_caidos": serviciosCaidos ?? 0,
        "masivo": masivo ?? 0,
        "ultima_observacion": ultimaObservacion ?? "",
      };
}

class Usuario {
  Usuario({
    this.id,
    this.dni,
    this.nombre,
    this.apellidos,
    this.email,
    this.celular,
  });

  final int? id;
  final int? dni;
  final String? nombre;
  final String? apellidos;
  final String? email;
  final int? celular;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"] ?? 0,
        dni: json["dni"] ?? 0,
        nombre: json["nombre"] ?? "",
        apellidos: json["apellidos"] ?? "",
        email: json["email"] ?? "",
        celular: json["celular"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "dni": dni ?? 0,
        "nombre": nombre ?? "",
        "apellidos": apellidos ?? "",
        "email": email ?? "",
        "celular": celular ?? "",
      };
}
