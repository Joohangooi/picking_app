// After importing necessary packages and classes

import 'package:picking_app/data/models/pickingModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'picking_database.db';
  static const _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, _databaseName);

    return await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE picking(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        documentNo TEXT,
        documentDate TEXT,
        customerName TEXT,
        zone TEXT,
        remarks TEXT,
        option TEXT,
        stock TEXT,
        location TEXT,
        bin TEXT,
        quantity DECIMAL DEFAULT 0,
        requestQty DECIMAL DEFAULT 0
      )
    ''');
  }

  Future<void> insertPicking(PickingModel picking) async {
    final db = await database;
    await db.insert(
      'picking',
      picking.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
