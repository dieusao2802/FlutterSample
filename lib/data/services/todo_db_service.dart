import 'package:sqflite/sqflite.dart';
import 'package:todo_list/data/services/database_service.dart';
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

    // Sử dụng factory fromMap để convert danh sách Todo tự động
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<void> deleteTodo(String id) async {
    final db = await _dbService.database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
