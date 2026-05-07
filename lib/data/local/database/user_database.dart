import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async {
    // File riêng biệt chỉ chứa bảng users
    final path = join(await getDatabasesPath(), 'user_v1.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE users(
            email TEXT PRIMARY KEY,
            name TEXT,
            password TEXT
          )
        ''');
      },
    );
  }
}
