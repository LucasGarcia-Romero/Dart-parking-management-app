import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'incidents.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE incidents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parkingName TEXT,
        dangerLevel INTEGER,
        date TEXT,
        comments TEXT
      )
    ''');
  }

  Future<int> insertIncident(Map<String, dynamic> incident) async {
    Database db = await database;
    return await db.insert('incidents', incident);
  }

  Future<List<Map<String, dynamic>>> getIncidents() async {
    Database db = await database;
    return await db.query('incidents');
  }

  Future<int> deleteIncident(int id) async {
    Database db = await database;
    return await db.delete('incidents', where: 'id = ?', whereArgs: [id]);
  }
}
