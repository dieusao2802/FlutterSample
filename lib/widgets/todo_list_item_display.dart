import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/todo_list.dart';

class TodoListItemDisplay extends ConsumerWidget {
  final String id;

  const TodoListItemDisplay({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('rebuilding Todo List Item Display: $id');

    final todoList = ref.watch(todoListProvider);
    final todo = todoList.firstWhere((element) => element.id == id);
    debugPrint('rebuilding Consumer Todo List Item Display: $id');

    return Text(
      '${todo.title}: ${todo.done}',
      style: const TextStyle(fontSize: 16.0),
    );
  }
}