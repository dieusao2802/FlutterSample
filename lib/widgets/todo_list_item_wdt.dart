import 'package:flutter/material.dart';
import 'package:todo_list/widgets/todo_list_item_display.dart';
import 'package:todo_list/widgets/todo_list_item_toggle_button.dart';

// Wrapper cho 1 dòng trong todo list — ghép 2 sub-widget độc lập:
//   - TodoListItemDisplay: hiển thị text title + done.
//   - TodoListItemToggleButton: button để toggle trạng thái done.
// Tách 2 widget này ra để mỗi cái subscribe provider riêng → tối ưu rebuild.
class TodoListItemWdt extends StatelessWidget {
  final String id; // Id của todo, dùng để 2 sub-widget tự lookup trong provider.

  const TodoListItemWdt({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    debugPrint('rebuilding ToDo List Item: $id'); // Log để debug khi rebuild — bỏ ở production.

    return Row(
      // Dàn 2 sub-widget cách đều: lề ngoài + giữa đều bằng nhau.
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TodoListItemDisplay(id: id), // Sub-widget hiển thị text.
        TodoListItemToggleButton(id: id), // Sub-widget button toggle.
      ],
    );
  }
}
