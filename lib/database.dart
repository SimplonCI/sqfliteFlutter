import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './etudiant.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableEtudiant = 'etudiant';
  final String columnId = 'id';
  final String columnNom = 'nom';
  final String columnPrenom = 'prenom';

  static Database _db;
  DatabaseHelper.internal();


  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }


  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'etudiants.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }


  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableEtudiant('
            '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$columnNom TEXT NOT NULL, '
            '$columnPrenom TEXT NOT NULL)'
    );
  }

  Future<int> saveEtudiant(Etudiant etudiant) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableEtudiant, etudiant.toMap());


//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableEtudiant ($columnNom, $columnPrenom) VALUES (\'${etudiant.nom}\', \'${etudiant.prenom}\')');

    return result;
  }


  Future<List> getAllEtudiants() async {
    var dbClient = await db;
    var result = await dbClient.query(tableEtudiant, columns: [columnId, columnNom, columnPrenom]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableEtudiant');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableEtudiant'));
  }



  Future<Etudiant> getEtudiant(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableEtudiant,
        columns: [columnId, columnNom, columnPrenom],
        where: '$columnId = ?',
        whereArgs: [id]);


//    var result = await dbClient.rawQuery('SELECT * FROM tableEtudiant WHERE $columnId = $id');

    if (result.length > 0) {
      return new Etudiant.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteEtudiant(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableEtudiant, where: '$columnId = ?', whereArgs: [id]);

//    return await dbClient.rawDelete('DELETE FROM tableEtudiant WHERE $columnId = $id');
  }

  Future<int> updateEtudiant(Etudiant etudiant) async {
    var dbClient = await db;
    return await dbClient.update(tableEtudiant, etudiant.toMap(), where: "$columnId = ?", whereArgs: [etudiant.id]);

    //    return await dbClient.rawUpdate(
//        'UPDATE tableEtudiant SET $columnNom = \'${etudiant.nom}\', $columnPrenom = \'${etudiant.prenom}\' WHERE $columnId = ${etudiant.id}');

  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}