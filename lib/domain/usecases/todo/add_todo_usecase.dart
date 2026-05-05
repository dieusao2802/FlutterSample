import 'package:todo_list/domain/entities/todo.dart';
import 'package:todo_list/domain/repositories/i_todo_repository.dart';

class AddTodoUseCase {
  final ITodoRepository _repository;

  AddTodoUseCase(this._repository);

  Future<void> call(Todo todo) {
    return _repository.addTodo(todo);
  }
}