import 'package:todo_list/domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    super.title,
    super.done = false,
  });

  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(id: todo.id, title: todo.title, done: todo.done);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': done ? 1 : 0,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String?,
      done: (map['isCompleted'] as int? ?? 0) == 1,
    );
  }
}