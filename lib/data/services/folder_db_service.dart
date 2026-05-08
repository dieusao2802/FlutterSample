import 'package:sqflite/sqflite.dart';
import 'package:todo_list/core/utils/string_utils.dart';
import 'package:todo_list/data/local/database/todo_database.dart';
import 'package:todo_list/model/folder.dart';

class FolderDbService {
  final DatabaseService _dbService;

  FolderDbService(this._dbService);

  Map<String, dynamic> _toRow(Folder folder) {
    final map = folder.toMap();
    map['name_normalized'] = StringUtils.removeDiacritics(folder.name.toLowerCase());
    return map;
  }

  String _escapeLike(String input) {
    return input
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
  }

  Future<void> insertFolder(Folder folder) async {
    final db = await _dbService.database;
    await db.insert('folders', _toRow(folder), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Folder>> getFolders() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('folders', orderBy: 'id DESC');
    return maps.map((m) => Folder.fromMap(m)).toList();
  }

  Future<List<Folder>> searchFolders(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return getFolders();

    final db = await _dbService.database;
    final normalized = StringUtils.removeDiacritics(trimmed.toLowerCase());
    final escaped = _escapeLike(normalized);

    final maps = await db.query(
      'folders',
      where: r"name_normalized LIKE ? ESCAPE '\'",
      whereArgs: ['%$escaped%'],
      orderBy: 'id DESC',
    );
    return maps.map((m) => Folder.fromMap(m)).toList();
  }

  Future<void> updateFolder(Folder folder) async {
    final db = await _dbService.database;
    await db.update('folders', _toRow(folder), where: 'id = ?', whereArgs: [folder.id]);
  }

  Future<void> deleteFolder(String id) async {
    final db = await _dbService.database;
    await db.delete('todos', where: 'folderId = ?', whereArgs: [id]);
    await db.delete('folders', where: 'id = ?', whereArgs: [id]);
  }
}
