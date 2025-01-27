import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WeatherDbHelper {
  static Database? _database;
  static const String tableName = 'weather_data';

  // Get database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // Initialize database
  static Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'weather.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id TEXT PRIMARY KEY,
            data TEXT,
            timestamp INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  // Save weather data
  static Future<void> saveWeatherData(
      String id, Map<String, dynamic> data) async {
    final db = await database;

    await db.insert(
      tableName,
      {
        'id': id,
        'data': json.encode(data),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get weather data
  static Future<Map<String, dynamic>?> getWeatherData(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return json.decode(results.first['data']);
    }
    return null;
  }


    // Get weather data
  static Future<int> getSavedTime(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first['timestamp'];
    }
    return 0;
  }
}
