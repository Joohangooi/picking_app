import 'package:picking_app/data/models/picking_main_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteMainDbHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'picking_main_table.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE picking_main_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            documentNo TEXT,
            documentDate TEXT,
            issueDate TEXT,
            remarks TEXT,
            customerName TEXT,
            pickBy TEXT,
            zone TEXT,
            dateCompleted TEXT,
            salesMan TEXT,
            issueBy TEXT,
            option TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertData(PickingMainModel data) async {
    final db = await database;
    await db.insert('picking_main_table', data.toJson());
  }

  static Future<bool> updateDetail(String documentNo, String option) async {
    try {
      final db = await database;
      final Map<String, dynamic> values = {
        'option': option,
      };
      int rowsUpdated = await db.update(
        'picking_main_table',
        values,
        where: 'documentNo = ?',
        whereArgs: [documentNo],
      );
      return rowsUpdated > 0;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteRecord(String documentNo) async {
    try {
      final db = await database;
      int rowsDeleted = await db.delete(
        'picking_main_table',
        where: 'documentNo = ?',
        whereArgs: [documentNo],
      );
      if (rowsDeleted > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error deleting record: $e');
      return false;
    }
  }

  static Future<List<PickingMainModel>> getAllRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('picking_main_table');
    return List.generate(maps.length, (i) {
      return PickingMainModel(
        documentNo: maps[i]['documentNo'] ?? '',
        documentDate: maps[i]['documentDate'] == null
            ? null
            : DateTime.tryParse(maps[i]['documentDate']),
        issueDate: maps[i]['issueDate'] == null
            ? null
            : DateTime.tryParse(maps[i]['issueDate']),
        remarks: maps[i]['remarks'] ?? '',
        customerName: maps[i]['customerName'] ?? '',
        pickBy: maps[i]['pickBy'] ?? '',
        issueBy: maps[i]['issueBy'] ?? '',
        salesMan: maps[i]['salesMan'] ?? '',
        zone: maps[i]['zone'] ?? '',
        dateCompleted: maps[i]['dateCompleted'] == null
            ? null
            : DateTime.tryParse(maps[i]['dateCompleted']),
        option: maps[i]['option'] ?? '',
      );
    });
  }

  static Future<List<PickingMainModel>> getDataByDocumentNo(
      String documentNo) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'picking_main_table',
      where: 'documentNo = ?',
      whereArgs: [documentNo],
    );

    return List.generate(maps.length, (i) {
      return PickingMainModel(
        documentNo: maps[i]['documentNo'],
        documentDate: DateTime.tryParse(maps[i]['documentDate']),
        issueDate: DateTime.tryParse(maps[i]['issueDate']),
        remarks: maps[i]['remarks'],
        customerName: maps[i]['customerName'],
        pickBy: maps[i]['pickBy'],
        zone: maps[i]['zone'],
        issueBy: maps[i]['issueBy'],
        salesMan: maps[i]['salesMan'],
        dateCompleted: DateTime.tryParse(maps[i]['dateCompleted']),
        option: maps[i]['option'],
      );
    });
  }

  static Future<bool> deleteAllPickingRecords() async {
    try {
      final db = await database;
      await db.delete('picking_main_table');
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<int> deleteCompletedRecords() async {
    final db = await database;
    return await db.delete(
      'picking_main_table',
      where: 'option = ?',
      whereArgs: ['c'],
    );
  }

  static Future<List<Map<String, dynamic>>> getLatestData(
      String documentNo) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('picking_main_table',
        where: 'documentNo = ?', whereArgs: [documentNo]);
    return maps;
  }
}
