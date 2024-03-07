// // After importing necessary packages and classes

// import 'dart:async';

// import 'package:picking_app/data/models/picking_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class SqliteDbHelper {
//   static const _databaseName = 'picking_database.db';
//   static const _databaseVersion = 1;

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     final path = await getDatabasesPath();
//     final databasePath = join(path, _databaseName);

//     return await openDatabase(
//       databasePath,
//       version: _databaseVersion,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE picking(
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       documentNo TEXT,
//       documentDate TEXT,
//       customerName TEXT,
//       zone TEXT,
//       remarks TEXT,
//       option TEXT,
//       description TEXT, 
//       stock TEXT,
//       location TEXT,
//       binShelfNo TEXT, 
//       quantity DECIMAL(18, 2),
//       requestQty DECIMAL(18, 2)
//     )
//   ''');
//   }

//   Future<void> insertPicking(PickingModel picking) async {
//     final db = await database;
//     Map<String, dynamic> data = picking.toJson();

//     // Check if the record with the same documentNo already exists
//     List<Map<String, dynamic>> existingRecords = await db.query(
//       'picking',
//       where: 'documentNo = ?',
//       whereArgs: [picking.pickedNo],
//     );

//     if (existingRecords.isNotEmpty) {
//       // Record already exists, do nothing or handle as needed
//       return;
//     }

//     // Record does not exist, proceed with insertion
//     if (picking.id == null) {
//       int id = await _getUniqueID(db);
//       data['id'] = id;
//       picking.id = id;
//     }

//     await db.insert(
//       'picking',
//       data,
//       conflictAlgorithm: ConflictAlgorithm.ignore,
//     );
//   }

//   Future<int> _getUniqueID(Database db) async {
//     // Query the database to get the maximum ID
//     List<Map<String, dynamic>> result =
//         await db.rawQuery('SELECT MAX(id) FROM picking');
//     int maxId = result[0]['MAX(id)'] ?? 0;

//     // Increment the maximum ID to generate a new unique ID
//     return maxId + 1;
//   }

//   Future<List<PickingModel>> getPickingRecords() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('picking');
//     return List.generate(maps.length, (i) {
//       return PickingModel(
//         date: maps[i]['documentDate'],
//         pickedNo: maps[i]['documentNo'],
//         companyName: maps[i]['customerName'],
//         zone: maps[i]['zone'],
//         location: maps[i]['location'],
//         remarks: maps[i]['remarks'],
//         option: maps[i]['option'],
//         binShelfNo: maps[i]['binShelfNo'],
//         description: maps[i]['description'],
//         quantity: maps[i]['quantity'].toDouble(),
//         requestQty: maps[i]['requestQty'].toDouble(),
//       );
//     });
//   }

//   Future<void> deleteAllPickingRecords() async {
//     final db = await database;
//     await db.delete('picking');
//   }
// }
