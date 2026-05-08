import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_v2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE folders(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            name_normalized TEXT NOT NULL,
            colorIndex INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE INDEX idx_folders_name_normalized ON folders(name_normalized)
        ''');
        await db.execute('''
          CREATE TABLE todos(
            id TEXT PRIMARY KEY,
            title TEXT,
            isCompleted INTEGER,
            folderId TEXT,
            FOREIGN KEY (folderId) REFERENCES folders (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}
