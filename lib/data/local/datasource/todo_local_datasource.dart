import 'package:sqflite/sqflite.dart';
import 'package:todo_list/data/local/database/app_database.dart';
import 'package:todo_list/data/models/todo_model.dart';

class TodoLocalDatasource {
  final AppDatabase _db;

  TodoLocalDatasource(this._db);

  Future<List<TodoModel>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('todos');
    return maps.map(TodoModel.fromMap).toList();
  }

  Future<void> insert(TodoModel todo) async {
    final db = await _db.database;
    await db.insert('todos', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(String id) async {
    final db = await _db.database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(TodoModel todo) async {
    final db = await _db.database;
    await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }
}