import 'package:sqflite/sqflite.dart';
import 'package:todo_list/data/local/database/todo_database.dart';
import 'package:todo_list/model/todo.dart';

class TodoDbService {
  final DatabaseService _dbService;

  TodoDbService(this._dbService);

  Future<void> insertTodo(Todo todo) async {
    final db = await _dbService.database;
    await db.insert(
      'todos',
      todo.toMap(), // Sử dụng toMap() đã định nghĩa trong Model
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Todo>> getTodos() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
  }

  Future<List<Todo>> getTodosByFolder(String folderId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'folderId = ?',
      whereArgs: [folderId],
    );
    return maps.map((m) => Todo.fromMap(m)).toList();
  }

  Future<void> deleteTodo(String id) async {
    final db = await _dbService.database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
