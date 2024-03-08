import 'package:picking_app/data/models/picking_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDbHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'picking_db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE picking_detail_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            line INTEGER,
            documentNo TEXT,
            documentDate TEXT,
            pickedNo TEXT,
            customerName TEXT,
            zone TEXT,
            remarks TEXT,
            option TEXT,
            description TEXT,
            stock TEXT,
            location TEXT,
            binShelfNo TEXT,
            quantity REAL,
            requestQty REAL
          )
        ''');
      },
    );
  }

  static Future<void> insertData(PickingModel data) async {
    final db = await database;
    await db.insert('picking_detail_table', data.toMap());
  }

  static Future<bool> updateQuantity(
      String documentNo, int line, double newQuantity) async {
    try {
      final db = await database;
      int rowsUpdated = await db.update(
        'picking_detail_table',
        {'quantity': newQuantity},
        where: 'documentNo = ? AND line = ?',
        whereArgs: [documentNo, line],
      );
      return rowsUpdated > 0;
    } catch (e) {
      return false;
    }
  }

  static Future<List<PickingModel>> getData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('picking_detail_table');
    return List.generate(maps.length, (i) {
      return PickingModel(
        documentNo: maps[i]['documentNo'],
        documentDate: maps[i]['documentDate'],
        pickedNo: maps[i]['pickedNo'],
        customerName: maps[i]['customerName'],
        zone: maps[i]['zone'],
        remarks: maps[i]['remarks'],
        option: maps[i]['option'],
        description: maps[i]['description'],
        stock: maps[i]['stock'],
        location: maps[i]['location'],
        binShelfNo: maps[i]['binShelfNo'],
        quantity: maps[i]['quantity'],
        requestQty: maps[i]['requestQty'],
        line: maps[i]['line'],
      );
    });
  }

  static Future<List<PickingModel>> getDataByDocumentNo(
      String documentNo) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'picking_detail_table',
      where: 'documentNo = ?',
      whereArgs: [documentNo],
    );

    return List.generate(maps.length, (i) {
      return PickingModel(
        documentNo: maps[i]['documentNo'],
        documentDate: maps[i]['documentDate'],
        pickedNo: maps[i]['pickedNo'],
        customerName: maps[i]['customerName'],
        zone: maps[i]['zone'],
        remarks: maps[i]['remarks'],
        option: maps[i]['option'],
        description: maps[i]['description'],
        stock: maps[i]['stock'],
        location: maps[i]['location'],
        binShelfNo: maps[i]['binShelfNo'],
        quantity: maps[i]['quantity'],
        requestQty: maps[i]['requestQty'],
        line: maps[i]['line'],
      );
    });
  }

  Future<void> deleteAllPickingRecords() async {
    final db = await database;
    await db.delete('picking_detail_table');
  }
}
