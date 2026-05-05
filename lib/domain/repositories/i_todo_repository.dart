import 'package:todo_list/domain/entities/todo.dart';

abstract class ITodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<void> toggleTodo(String id);
}