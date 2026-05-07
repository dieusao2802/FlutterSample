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
    // Đổi tên file thành app_v1.db để ép tạo mới hoàn toàn
    String path = join(await getDatabasesPath(), 'app_v1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tạo bảng folders trước
        await db.execute('''
          CREATE TABLE folders(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            colorIndex INTEGER NOT NULL
          )
        ''');
        // Sau đó tạo bảng todos có khóa ngoại trỏ tới folders
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
