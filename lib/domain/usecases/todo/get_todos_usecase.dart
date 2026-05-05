import 'package:todo_list/domain/entities/todo.dart';
import 'package:todo_list/domain/repositories/i_todo_repository.dart';

class GetTodosUseCase {
  final ITodoRepository _repository;

  GetTodosUseCase(this._repository);

  Future<List<Todo>> call() {
    return _repository.getTodos();
  }
}