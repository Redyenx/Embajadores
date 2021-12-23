import 'package:embajadores/data/services/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract class DatabaseHelper {
  static Database? _db;

  static int get _version => 1;
  static const ownerTable = 'owner';
  static const columnStoreId = 'id';
  static const columnStoreCity = 'city';
  static const columnStoreName = 'store';
  static const columnStoreStatus = 'status';
  static const columnStoreNotes = 'notes';
  static const columnStatusTime = 'time';

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      var databasesPath = await getDatabasesPath();
      final _path = p.join(databasesPath, 'crud.db');
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $ownerTable(
      $columnStoreId INTEGER PRIMARY KEY, 
      $columnStoreCity TEXT,
      $columnStoreName TEXT,
      $columnStoreStatus TEXT,
      $columnStoreNotes TEXT,
      $columnStatusTime TEXT      
      )
      ''');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db!.query(table);

  static Future<List<Map<String, dynamic>>> qQuery(
      String table, String columns, String where, Model model) async {
    return await _db!.query(table,
        columns: [columns], where: 'id = ?', whereArgs: [model.id]);
  }

  static Future<List<Map<String, dynamic>>> rawQuery(sql) async {
    return await _db!.rawQuery(sql);
  }

  static Future<int> insert(String table, Model model) async =>
      await _db!.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async => await _db!
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db!.delete(table, where: 'id = ?', whereArgs: [model.id]);

  static Future<Batch> batch() async => _db!.batch();
}
