import 'package:todo_list/domain/repositories/i_todo_repository.dart';

class ToggleTodoUseCase {
  final ITodoRepository _repository;

  ToggleTodoUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.toggleTodo(id);
  }
}