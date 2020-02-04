import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> database() async {
    // This will give us the path of the database and it works in both IOS and Android
    final dbpath = await sql.getDatabasesPath();
    // This will open a database if the db not exist then we call the oncreate callback
    // path.join is used to add up the paths
    // the oncreate takes db and version number as parameters
    return  await sql.openDatabase(path.join(dbpath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL,loc_lng REAL, address Text)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    // conflictAlgorithm is basically runs when there is some issue with inserting into db
    // over here we add replace in case if the id is same it will not give error it will simply replace it
    final db = await DBHelper.database();
    
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();

    return db.query(table);


  }


}

