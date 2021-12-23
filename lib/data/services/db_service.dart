import 'package:embajadores/data/models/owner.dart';
import 'package:embajadores/data/services/db_helper.dart';

class DBService {
  Future<bool> registryOwner(Owner owner) async {
    await DatabaseHelper.init();
    bool isSaved = false;
    int inserted = await DatabaseHelper.insert(Owner.table, owner);
    isSaved = inserted == 1 ? true : false;
    return isSaved;
  }

  Future<List<Owner>> getOwner() async {
    await DatabaseHelper.init();
    List<Map<String, dynamic>> owner = await DatabaseHelper.query(Owner.table);
    return owner.map((item) => Owner.fromMap(item)).toList();
  }

  Future<List<Owner>> getOpenedStore(String status) async {
    await DatabaseHelper.init();
    List<Map<String, dynamic>> owner = await DatabaseHelper.rawQuery(
        "SELECT * FROM owner WHERE status = '$status'");
    return owner.map((item) => Owner.fromMap(item)).toList();
  }

  Future<bool> updateOwner(Owner owner) async {
    await DatabaseHelper.init();
    bool isSaved = false;
    int inserted = await DatabaseHelper.update(Owner.table, owner);
    isSaved = inserted == 1 ? true : false;
    return isSaved;
  }

  Future<bool> deleteOwner(Owner owner) async {
    await DatabaseHelper.init();
    bool isSaved = false;
    int inserted = await DatabaseHelper.delete(Owner.table, owner);
    isSaved = inserted == 1 ? true : false;
    return isSaved;
  }
}
