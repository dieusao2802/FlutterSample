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

  Todo copyWith({String? id, String? title, bool? done}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  @override
  List<Object?> get props => [id, title, done];
}