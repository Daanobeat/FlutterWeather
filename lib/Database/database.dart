import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;

  DBProvider._();
  static final DBProvider db = DBProvider._();

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;


}
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "WeatherDB.db";
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Weather ("
          "dt LONG PRIMARY KEY,"
          "temp DOUBLE,"
          "pressure DOUBLE,"
          "humidity DOUBLE,"
          "main TEXT,"
          "description TEXT,"
          "icon TEXT"
          ")");
    });
  }
}