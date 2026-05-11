import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/journal.dart';

class TodoListNotifier extends Notifier<List<Journal>> {
  final Map<String, Journal> _items = {};

  @override
  List<Journal> build() => [];

  void add(Journal newItem) {
    _items[newItem.id] = newItem;
    state = _items.values.toList();
  }

  void remove(Journal removedItem) {
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

final todoListProvider = NotifierProvider<TodoListNotifier, List<Journal>>(TodoListNotifier.new);