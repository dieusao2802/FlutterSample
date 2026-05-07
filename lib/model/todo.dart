import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String? title;
  final bool done;
  final String? folderId;

  const Todo({
    required this.id,
    this.title,
    this.done = false,
    this.folderId,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? done,
    String? folderId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      folderId: folderId ?? this.folderId,
    );
  }

  // Chuyển sang Map để lưu vào SQLite (SQLite không hỗ trợ kiểu bool nên dùng 0 và 1)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': done ? 1 : 0,
      'folderId': folderId,
    };
  }

  // Chuyển từ Map (Database trả về) sang Object Todo
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] ?? '',
      title: map['title'],
      done: map['isCompleted'] == 1,
      folderId: map['folderId'],
    );
  }

  @override
  List<Object?> get props => [id, title, done, folderId];
}
