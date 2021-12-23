import 'dart:convert';
import 'package:equatable/equatable.dart';

ReportIncident reportIncidentFromJson(String str) =>
    ReportIncident.fromJson(json.decode(str));

String reportIncidentToJson(ReportIncident data) => json.encode(data.toJson());

class ReportIncident {
  ReportIncident({
    this.tipo,
    this.idTienda,
    this.idServicio,
    this.idTipoFalla,
    this.idEstado,
    this.masivo,
    this.usuariosOperacion,
    this.usuariosAfectados,
    this.fechaApertura,
    this.fechaCierre,
    this.observacion,
    this.componentes,
  });

  int? tipo;
  int? idTienda;
  int? idServicio;
  int? idTipoFalla;
  int? idEstado;
  int? masivo;
  int? usuariosOperacion;
  int? usuariosAfectados;
  DateTime? fechaApertura;
  DateTime? fechaCierre;
  String? observacion;
  List<int>? componentes;

  factory ReportIncident.fromJson(Map<String, dynamic> json) => ReportIncident(
        tipo: json["tipo"] ?? 0,
        idTienda: json["id_tienda"] ?? 0,
        idServicio: json["id_servicio"] ?? 0,
        idTipoFalla: json["id_tipo_falla"] ?? 0,
        idEstado: json["id_estado"] ?? 0,
        masivo: json["masivo"] ?? false,
        usuariosOperacion: json["usuarios_operacion"] ?? 0,
        usuariosAfectados: json["usuarios_afectados"] ?? 0,
        fechaApertura: json["fecha_apertura"] == null
            ? DateTime.now()
            : DateTime.parse(json["fecha_apertura"]),
        fechaCierre: json["fecha_cierre"] == null
            ? DateTime.now()
            : DateTime.parse(json["fecha_cierre"]),
        observacion: json["observacion"] ?? "Sin comentarios",
        componentes: json["componentes"] == null
            ? []
            : List<int>.from(json["componentes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "tipo": tipo ?? 0,
        "id_tienda": idTienda ?? 0,
        "id_servicio": idServicio ?? 0,
        "id_tipo_falla": idTipoFalla ?? 0,
        "id_estado": idEstado ?? 0,
        "masivo": masivo ?? false,
        "usuarios_operacion": usuariosOperacion ?? 0,
        "usuarios_afectados": usuariosAfectados ?? 0,
        "fecha_apertura":
            fechaApertura == null ? "" : fechaApertura!.toIso8601String(),
        "fecha_cierre":
            fechaCierre == null ? "" : fechaCierre!.toIso8601String(),
        "observacion": observacion ?? "Sin comentarios",
        "componentes": componentes == null
            ? []
            : List<dynamic>.from(componentes!.map((x) => x)),
      };
}

//--------------------------------------|||--------------------------------------\\

OpenCloseStore openCloseStoreFromJson(String str) =>
    OpenCloseStore.fromJson(json.decode(str));

String openCloseStoreToJson(OpenCloseStore data) => json.encode(data.toJson());

class OpenCloseStore {
  OpenCloseStore({
    this.tipo,
    this.idTienda,
    this.usuariosOperacion,
    this.fechaApertura,
    this.fechaCierre,
    this.observacion,
  });

  int? tipo;
  int? idTienda;
  int? usuariosOperacion;
  String? fechaApertura;
  String? fechaCierre;
  String? observacion;

  factory OpenCloseStore.fromJson(Map<String, dynamic> json) => OpenCloseStore(
        tipo: json["tipo"],
        idTienda: json["id_tienda"],
        usuariosOperacion: json["usuarios_operacion"],
        fechaApertura: json["fecha_apertura"],
        fechaCierre: json["fecha_cierre"],
        observacion: json["observacion"] ?? "Sin comentarios",
      );

  Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "id_tienda": idTienda,
        "usuarios_operacion": usuariosOperacion ?? 0,
        "fecha_apertura": fechaApertura,
        "fecha_cierre": fechaCierre,
        "observacion": observacion ?? "Sin comentarios",
      };
}

GetIncidents getIncidentsFromJson(String str) =>
    GetIncidents.fromJson(json.decode(str));

String getIncidentsToJson(GetIncidents data) => json.encode(data.toJson());

class GetIncidents {
  GetIncidents({
    this.status,
    this.message,
    this.data,
  });

  final bool? status;
  final String? message;
  final List<Incident>? data;

  factory GetIncidents.fromJson(Map<String, dynamic> json) => GetIncidents(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        data: json["data"] == null
            ? null
            : List<Incident>.from(
                json["data"].map((x) => Incident.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status ?? "",
        "message": message ?? "",
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Incident {
  Incident({
    this.idIncidencia,
    this.incTipo,
    this.incUsuariosOperacion,
    this.incUsuariosAfectados,
    this.incFechaApertura,
    this.incFechaCierre,
    this.incMasivo,
    this.incObservacion,
    this.idUsuario,
    this.usuNombre,
    this.usuApellidos,
    this.idCiudad,
    this.ciuNombre,
    this.idTienda,
    this.tieNombre,
    this.tieEstadoOperacion,
    this.idServicio,
    this.serNombre,
    this.idTipoFalla,
    this.tpfNombre,
    this.idEstado,
    this.ineNombre,
    this.observaciones,
    this.componentes,
  });

  final int? idIncidencia;
  final int? incTipo;
  final int? incUsuariosOperacion;
  final int? incUsuariosAfectados;
  final DateTime? incFechaApertura;
  final DateTime? incFechaCierre;
  late final int? incMasivo;
  final String? incObservacion;
  final int? idUsuario;
  final String? usuNombre;
  final String? usuApellidos;
  final int? idCiudad;
  final String? ciuNombre;
  final int? idTienda;
  final String? tieNombre;
  final int? tieEstadoOperacion;
  final int? idServicio;
  final String? serNombre;
  final int? idTipoFalla;
  final String? tpfNombre;
  final int? idEstado;
  final String? ineNombre;
  final String? observaciones;
  final String? componentes;

  factory Incident.fromJson(Map<String, dynamic> json) => Incident(
        idIncidencia: json["id_incidencia"] ?? 0,
        incTipo: json["inc_tipo"] ?? 0,
        incUsuariosOperacion: json["inc_usuarios_operacion"] ?? 0,
        incUsuariosAfectados: json["inc_usuarios_afectados"] ?? 0,
        incFechaApertura: json["inc_fecha_apertura"] == null
            ? null
            : DateTime.parse(json["inc_fecha_apertura"]),
        incFechaCierre: json["inc_fecha_cierre"] == null
            ? null
            : DateTime.parse(json["inc_fecha_cierre"]),
        incMasivo: json["inc_masivo"] ?? false,
        incObservacion: json["inc_observacion"] ?? "",
        idUsuario: json["id_usuario"] ?? 0,
        usuNombre: json["usu_nombre"] ?? "",
        usuApellidos: json["usu_apellidos"] ?? "",
        idCiudad: json["id_ciudad"] ?? 0,
        ciuNombre: json["ciu_nombre"] ?? "",
        idTienda: json["id_tienda"] ?? 0,
        tieNombre: json["tie_nombre"] ?? "",
        tieEstadoOperacion: json["tie_estado_operacion"] ?? 0,
        idServicio: json["id_servicio"] ?? 0,
        serNombre: json["ser_nombre"] ?? "",
        idTipoFalla: json["id_tipo_falla"] ?? 0,
        tpfNombre: json["tpf_nombre"] ?? "",
        idEstado: json["id_estado"] ?? 0,
        ineNombre: json["ine_nombre"] ?? "",
        observaciones: json["observaciones"] ?? "Sin comentarios",
        componentes: json["componentes"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id_incidencia": idIncidencia ?? 0,
        "inc_tipo": incTipo ?? 0,
        "inc_usuarios_operacion": incUsuariosOperacion ?? 0,
        "inc_usuarios_afectados": incUsuariosAfectados ?? 0,
        "inc_fecha_apertura": incFechaApertura == null
            ? null
            : incFechaApertura!.toIso8601String(),
        "inc_fecha_cierre":
            incFechaCierre == null ? null : incFechaCierre!.toIso8601String(),
        "inc_masivo": incMasivo ?? 0,
        "inc_observacion": incObservacion ?? "",
        "id_usuario": idUsuario ?? 0,
        "usu_nombre": usuNombre ?? "",
        "usu_apellidos": usuApellidos ?? "",
        "id_ciudad": idCiudad ?? 0,
        "ciu_nombre": ciuNombre ?? "",
        "id_tienda": idTienda ?? 0,
        "tie_nombre": tieNombre ?? "",
        "tie_estado_operacion": tieEstadoOperacion ?? 0,
        "id_servicio": idServicio ?? 0,
        "ser_nombre": serNombre ?? 0,
        "id_tipo_falla": idTipoFalla ?? 0,
        "tpf_nombre": tpfNombre ?? "",
        "id_estado": idEstado ?? 0,
        "ine_nombre": ineNombre ?? "",
        "observaciones": observaciones ?? "Sin comentarios",
        "componentes": componentes ?? [],
      };
}

UpdateIncident updateIncidentFromJson(String str) =>
    UpdateIncident.fromJson(json.decode(str));

String updateIncidentToJson(UpdateIncident data) => json.encode(data.toJson());

class UpdateIncident {
  UpdateIncident({
    this.idEstado,
    this.usuariosAfectados,
    this.descripcion,
  });

  int? idEstado;
  int? usuariosAfectados;
  String? descripcion;

  factory UpdateIncident.fromJson(Map<String, dynamic> json) => UpdateIncident(
        idEstado: json["id_estado"] ?? "",
        usuariosAfectados: json["usuarios_afectados"] ?? 0,
        descripcion: json["descripcion"] ?? "Sin comentarios",
      );

  Map<String, dynamic> toJson() => {
        "id_estado": idEstado ?? 0,
        "usuarios_afectados": usuariosAfectados ?? 0,
        "descripcion": descripcion ?? "",
      };
}

GetUpdates getUpdatesFromJson(String str) =>
    GetUpdates.fromJson(json.decode(str));

String getUpdatesToJson(GetUpdates data) => json.encode(data.toJson());

class GetUpdates {
  GetUpdates({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Update>? data;

  factory GetUpdates.fromJson(Map<String, dynamic> json) => GetUpdates(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? null
            : List<Update>.from(json["data"].map((x) => Update.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status ?? "",
        "message": message ?? "",
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Update extends Equatable {
  const Update({
    this.idEstado,
    this.nombreEstado,
    this.descripcion,
    this.fechaCreacion,
  });

  final int? idEstado;
  final String? nombreEstado;
  final String? descripcion;
  final DateTime? fechaCreacion;

  @override
  List<Object> get props =>
      [idEstado!, nombreEstado!, descripcion!, fechaCreacion!];

  factory Update.fromJson(Map<String, dynamic> json) => Update(
        idEstado: json["id_estado"] ?? 0,
        nombreEstado: json["nombre_estado"] ?? "",
        descripcion: json["descripcion"] ?? "",
        fechaCreacion: json["fecha_creacion"] == null
            ? null
            : DateTime.parse(json["fecha_creacion"]),
      );

  Map<String, dynamic> toJson() => {
        "id_estado": idEstado ?? 0,
        "nombre_estado": nombreEstado ?? "",
        "descripcion": descripcion ?? "",
        "fecha_creacion":
            fechaCreacion == null ? null : fechaCreacion!.toIso8601String(),
      };
}
