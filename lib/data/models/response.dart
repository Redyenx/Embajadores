import 'dart:convert';

ResponseStatus responseStatusFromJson(String str) =>
    ResponseStatus.fromJson(json.decode(str));

String responseStatusToJson(ResponseStatus data) => json.encode(data.toJson());

class ResponseStatus {
  ResponseStatus({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory ResponseStatus.fromJson(Map<String, dynamic> json) => ResponseStatus(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.idIncidencia,
  });

  int? idIncidencia;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idIncidencia: json["id_incidencia"],
      );

  Map<String, dynamic> toJson() => {
        "id_incidencia": idIncidencia,
      };
}
