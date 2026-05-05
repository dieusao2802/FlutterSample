import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String? title;
  final bool done;

  const Todo({
    required this.id,
    this.title,
    this.done = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? done,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  // Chuyển sang Map để lưu vào SQLite (SQLite không hỗ trợ kiểu bool nên dùng 0 và 1)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': done ? 1 : 0,
    };
  }

  // Chuyển từ Map (Database trả về) sang Object Todo
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] ?? '',
      title: map['title'],
      done: map['isCompleted'] == 1,
    );
  }

  @override
  List<Object?> get props => [id, title, done];
}
