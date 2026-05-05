import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'todo_app.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE todos(
            id TEXT PRIMARY KEY,
            title TEXT,
            isCompleted INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE users(
            email TEXT PRIMARY KEY,
            name TEXT,
            password TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, _) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE users(
              email TEXT PRIMARY KEY,
              name TEXT,
              password TEXT
            )
          ''');
        }
      },
    );
  }
}