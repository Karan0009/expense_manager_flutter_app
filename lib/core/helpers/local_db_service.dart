import 'dart:io';
import 'package:expense_manager/config/app_config.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {
  static const String _dbName = 'expensio_store.db';
  static final LocalDbService _instance = LocalDbService._internal();
  factory LocalDbService() => _instance;
  LocalDbService._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB(_dbName);
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> deleteDb() async {
    final db = await database;
    await db.close();
    _db = null; // Reset the instance
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _dbName);
    await deleteDatabase(path);
  }

  // 🔧 Customize your initial tables here
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${AppConfig.rawTransactionsLocalTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT,
        status TEXT
        status TEXT DEFAULT 'PENDING',
        created_at TEXT DEFAULT (datetime('now')),
        updated_at TEXT DEFAULT (datetime('now'))
      )
    ''');
  }

  // CREATE
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  // READ (All rows or by optional [where])
  Future<List<Map<String, dynamic>>> queryAll(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    final data = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    return data;
  }

  // READ one by id
  Future<Map<String, dynamic>?> queryById(String table, int id) async {
    final db = await database;
    final res =
        await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
    return res.isNotEmpty ? res.first : null;
  }

  // UPDATE
  Future<int> update(String table, Map<String, dynamic> data, int id) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  // DELETE
  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // DELETE ALL
  Future<int> deleteAll(String table) async {
    final db = await database;
    return await db.delete(table);
  }

  // DROP a table
  Future<void> dropTable(String table) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $table');
  }

  // Wipeout everything like a digital nuke
  Future<void> resetDatabase() async {
    final db = await database;
    final tables =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    for (var table in tables) {
      final tableName = table['name'];
      if (tableName != 'android_metadata' && tableName != 'sqlite_sequence') {
        await db.execute("DROP TABLE IF EXISTS $tableName");
      }
    }
  }

  Future<void> query(String sql, [List<Object?>? arguments]) async {
    final db = await database;
    await db.rawQuery(sql, arguments);
  }
}
