import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/todo_list.dart';

// Sub-widget hiển thị nội dung của 1 todo (title + trạng thái done).
// Tự subscribe todoListProvider và tìm record theo id → chỉ rebuild khi list thay đổi.
class TodoListItemDisplay extends ConsumerWidget {
  final String id;

  const TodoListItemDisplay({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('rebuilding Todo List Item Display: $id');

    final todoList = ref.watch(todoListProvider);
    // Lưu ý: firstWhere không có orElse → nếu id không tồn tại trong list sẽ throw StateError.
    // Trong flow hiện tại, parent đã đảm bảo id luôn nằm trong list (build từ chính list đó),
    // nhưng nên cân nhắc bổ sung orElse phòng race condition khi item bị remove giữa chừng.
    final todo = todoList.firstWhere((element) => element.id == id);
    debugPrint('rebuilding Consumer Todo List Item Display: $id');

    return Text(
      '${todo.title}: ${todo.done}',
      style: const TextStyle(fontSize: 16.0),
    );
  }
}
