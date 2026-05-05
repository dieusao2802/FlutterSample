import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/todo_list.dart';

class TodoListItemToggleButton extends ConsumerWidget {
  final String id;

  const TodoListItemToggleButton({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('build Toggle Item Button: $id');

    final todoList = ref.watch(todoListProvider);
    final todo = todoList.firstWhere((element) => element.id == id);
    debugPrint('rebuilding Consumer Todo List Item Toggle Item Button: $id');

    return ElevatedButton(
      onPressed: () {
        ref.read(todoListProvider.notifier).toggleTodo(id);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: todo.done ? Colors.blue : Colors.red,
      ),
      child: const Icon(
        Icons.refresh,
        color: Colors.white70,
      ),
    );
  }
}