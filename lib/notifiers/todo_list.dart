import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/todo.dart';

class TodoListNotifier extends Notifier<List<Todo>> {
  final Map<String, Todo> _items = {};

  @override
  List<Todo> build() => [];

  void add(Todo newItem) {
    _items[newItem.id] = newItem;
    state = _items.values.toList();
  }

  void remove(Todo removedItem) {
    _items.remove(removedItem.id);
    state = _items.values.toList();
  }

  void toggleTodo(String id) {
    final todo = _items[id];
    if (todo != null) {
      _items[id] = todo.copyWith(done: !todo.done);
      state = _items.values.toList();
    }
  }

  void clearDoneItems() {
    _items.removeWhere((key, value) => value.done);
    state = _items.values.toList();
  }
}

final todoListProvider = NotifierProvider<TodoListNotifier, List<Todo>>(TodoListNotifier.new);