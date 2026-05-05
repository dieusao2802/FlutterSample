import 'package:flutter/material.dart';
import 'package:todo_list/widgets/todo_list_item_display.dart';
import 'package:todo_list/widgets/todo_list_item_toggle_button.dart';

class TodoListItemWdt extends StatelessWidget {
  final String id;

  const TodoListItemWdt({super.key,  required this.id});

  @override
  Widget build(BuildContext context) {
    debugPrint('rebuilding ToDo List Item: $id');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TodoListItemDisplay(id: id),
        TodoListItemToggleButton(id: id),
      ],
    );
  }
}
