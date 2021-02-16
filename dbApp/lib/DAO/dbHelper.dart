import 'package:dbApp/models/Training.dart';
import 'package:dbApp/models/Workshop_List.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ignore: camel_case_types
class dbHelper {
  final int version = 1;
  Database db;

  Future<Database> openDB() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'workshops.db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE workshops(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, priority INTEGER)');
        database.execute(
            'CREATE TABLE trainings(id INTEGER PRIMARY KEY AUTOINCREMENT, idWorkshop INTEGER, name TEXT, trainer TEXT, note INTEGER, ' +
                'FOREIGN KEY(idWorkshop) REFERENCES workshops(id))');
      }, version: version);
    }
    return db;
  }

  Future<int> insertWorkshop(Workshop_List wl) async {
    int id = await this.db.insert(
          'workshops',
          wl.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<int> insertTraining(Training tr) async {
    int id = await this.db.insert(
          'trainings',
          tr.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<List<Workshop_List>> getList() async {
    final List<Map<String, dynamic>> maps = await db.query('workshops');
    return List.generate(maps.length, (i) {
      return Workshop_List(
        id: maps[i]['id'],
        name: maps[i]['name'],
        priority: maps[i]['priority'],
      );
    });
  }

  Future<List<Training>> getTraining(int id) async {
    final List<Map<String, dynamic>> result = await db.query('trainings',
        where: 'idWorkshop = ?', whereArgs: [id], limit: 1);
    return List.generate(result.length, (index) {
      return Training(
        id: result[index]['id'],
        name: result[index]['name'],
        note: result[index]['note'],
        idWorkshop: result[index]['idWorkshop'],
        trainer: result[index]['trainer'],
      );
    });
  }

  Future<int> deleteWorkshop(Workshop_List wk) async {
    int result = await db
        .delete('trainings', where: "idWorkshop = ?", whereArgs: [wk.id]);
    result = await db.delete('workshops', where: "id= ?", whereArgs: [wk.id]);

    return result;
  }
}

/* 
 insert data in database done

 get data from database 
 show it fl ui 

 delete data
 
  */
