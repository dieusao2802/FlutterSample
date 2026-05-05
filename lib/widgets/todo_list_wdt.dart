import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/notifiers/todo_list.dart';
import 'package:todo_list/widgets/todo_list_item_wdt.dart';

class TodolistWgt extends ConsumerWidget {
  const TodolistWgt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);
    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (context, index) {
        return TodoListItemWdt(id: todoList[index].id);
      },
    );
  }
}