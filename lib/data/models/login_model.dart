import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.idRol,
    this.dni,
    this.nombre,
    this.apellidos,
    this.email,
    this.celular,
    this.estado,
    this.token,
  });

  final int? id;
  final int? idRol;
  final int? dni;
  final String? nombre;
  final String? apellidos;
  final String? email;
  final int? celular;
  final int? estado;
  final String? token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? 0,
        idRol: json["id_rol"] ?? 0,
        dni: json["dni"] ?? 0,
        nombre: json["nombre"] ?? "",
        apellidos: json["apellidos"] ?? "",
        email: json["email"] ?? "",
        celular: json["celular"] ?? 0,
        estado: json["estado"] ?? 0,
        token: json["token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "id_rol": idRol ?? 0,
        "dni": dni ?? 0,
        "nombre": nombre ?? "",
        "apellidos": apellidos ?? "",
        "email": email ?? "",
        "celular": celular ?? "",
        "estado": estado ?? 0,
        "token": token ?? "",
      };
}
