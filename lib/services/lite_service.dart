import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:superfam_1/models/pair_field_model.dart';
import 'package:superfam_1/models/pair_model.dart';

class PairDatabase {
  // calling the private constructor
  static final PairDatabase instance = PairDatabase._internal();

  // refers to the database from the sqflite package
  static Database? _database;

  // private contructor for our database calss
  PairDatabase._internal();

  Future<Database> get database async {
    // checks if the database exists, if it does not then initialize one
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // gets the path of the database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/notes.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  // this mehtod is used to define the database schema
  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE ${PairFields.tableName} (
          ${PairFields.id} ${PairFields.idType},
          ${PairFields.key} ${PairFields.textType},
          ${PairFields.value} ${PairFields.textType},
          ${PairFields.createdTime} ${PairFields.textType}
        )
      ''');
  }

  // create operation
  Future<PairModel> create(PairModel pair) async {
    final db = await instance.database;
    final id = await db.insert(PairFields.tableName, pair.toJson());
    log("id: $id");
    return pair.copy(id: id);
  }

  // read operation
  Future<PairModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      PairFields.tableName,
      columns: PairFields.values,
      where: '${PairFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PairModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // read all operations
  Future<List<PairModel>> readAll() async {
    final db = await instance.database;
    final result = await db.query(PairFields.tableName);
    return result.map((json) => PairModel.fromJson(json)).toList();
  }

  // update operation
  Future<int> update(PairModel note) async {
    final db = await instance.database;
    return db.update(
      PairFields.tableName,
      note.toJson(),
      where: '${PairFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  // delete operations
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      PairFields.tableName,
      where: '${PairFields.id} = ?',
      whereArgs: [id],
    );
  }

  // after we perform all the CRUD operatrions IT IS NECESSARY TO CLOSE THE DB
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}


// --------------------------------------
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseService {
//   Database? _database;

//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }
//     _database = await _initialize();
//     return _database!;
//   }

//   //
//   Future<String> get fullPath async {
//     const name = 'pairs.db';
//     final path = await getDatabasesPath();
//     return join(path, name);
//   }

//   //
//   Future<Database> _initialize() async {
//     final path = await fullPath;
//     var database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: create,
//       singleInstance: true,
//     );
//     return database;
//   }

//   //
//   Future<void> create(Database database, int version) async {
//     await PairDb().createTable(database);
//   }
// }

// class PairDb {
//   final tableName = "pairs";

//   Future<void> createTable(Database database) async {
//     await database.execute('''CREATE TABLE IF NOT EXISTS $tableName (
//       "id"  INTEGER NOT NULL,
//       "key"  TEXT NOT NULL,
//       "value"  TEXT NOT NULL,
//       PRIMARY KEY("id" AUTOINCREMENT)
//     );''');
//   }
// }
