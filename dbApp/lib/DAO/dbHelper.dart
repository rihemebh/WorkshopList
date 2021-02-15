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
            'CREATE TABLE workshops(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
        database.execute(
            'CREATE TABLE trainings(id INTEGER PRIMARY KEY, idWorkshop INTEGER, name TEXT, trainer TEXT, note INTEGER, ' +
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
}

/* 
 insert data in database done

 get data from database 
 show it fl ui 

 delete data
 
  */
