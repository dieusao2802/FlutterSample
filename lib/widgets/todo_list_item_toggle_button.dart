import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/todo_list.dart';

// Sub-widget chứa button toggle done của 1 todo.
// Màu nền của button đổi theo trạng thái done (xanh = đã xong, đỏ = chưa).
class TodoListItemToggleButton extends ConsumerWidget {
  final String id; // Id của todo cần toggle.

  const TodoListItemToggleButton({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('build Toggle Item Button: $id');

    final todoList = ref.watch(todoListProvider);
    // Lưu ý: firstWhere không có orElse → sẽ throw StateError nếu id biến mất khỏi list.
    // Hiện tại an toàn vì parent build từ chính list đó, nhưng nên thêm orElse cho chắc chắn.
    final todo = todoList.firstWhere((element) => element.id == id);
    debugPrint('rebuilding Consumer Todo List Item Toggle Item Button: $id');

    return ElevatedButton(
      onPressed: () {
        // Gọi notifier để toggle field done trong record.
        // State mới sẽ trigger rebuild các widget đang watching.
        ref.read(todoListProvider.notifier).toggleTodo(id);
      },
      style: ElevatedButton.styleFrom(
        // Done = xanh (đã hoàn thành), chưa done = đỏ (cần làm).
        backgroundColor: todo.done ? Colors.blue : Colors.red,
      ),
      child: const Icon(
        Icons.refresh, // Icon refresh ngụ ý "đổi trạng thái".
        color: Colors.white70, // Trắng 70% opacity — nhẹ hơn pure white.
      ),
    );
  }
}
