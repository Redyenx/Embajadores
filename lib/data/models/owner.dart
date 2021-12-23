import 'package:embajadores/data/services/model.dart';

class Owner extends Model {
  static String table = 'owner';

  int? id;
  String? city;
  String? store;
  String? status;
  String? notes;
  String? time;

  Owner({this.id, this.city, this.store, this.status, this.notes, this.time});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Owner &&
          runtimeType == other.runtimeType &&
          store == other.store;

  @override
  int get hashCode => store.hashCode;

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'city': city,
      'store': store,
      'status': status,
      'notes': notes,
      'time': time,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Owner fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id'],
      city: map['city'],
      store: map['store'],
      status: map['status'],
      notes: map['notes'],
      time: map['time'],
    );
  }
}
