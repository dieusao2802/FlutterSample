import 'package:sqflite/sqflite.dart';
import 'package:todo_list/data/local/database/todo_database.dart';
import 'package:todo_list/model/folder.dart';

class FolderDbService {
  final DatabaseService _dbService;

  FolderDbService(this._dbService);

  Future<void> insertFolder(Folder folder) async {
    final db = await _dbService.database;
    await db.insert('folders', folder.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Folder>> getFolders() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('folders');
    return maps.map((m) => Folder.fromMap(m)).toList();
  }

  Future<void> updateFolder(Folder folder) async {
    final db = await _dbService.database;
    await db.update('folders', folder.toMap(), where: 'id = ?', whereArgs: [folder.id]);
  }

  // Cascade: xóa tất cả todos trong folder trước, sau đó xóa folder
  Future<void> deleteFolder(String id) async {
    final db = await _dbService.database;
    await db.delete('todos', where: 'folderId = ?', whereArgs: [id]);
    await db.delete('folders', where: 'id = ?', whereArgs: [id]);
  }
}
