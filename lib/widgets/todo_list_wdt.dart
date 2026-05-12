import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/notifiers/todo_list.dart';
import 'package:todo_list/widgets/todo_list_item_wdt.dart';

// Widget hiển thị toàn bộ danh sách todo từ todoListProvider.
// Mỗi item con (TodoListItemWdt) chỉ nhận `id`, sau đó tự subscribe vào provider để render
// → khi 1 item thay đổi, chỉ item đó rebuild, không kéo theo cả list.
class TodolistWgt extends ConsumerWidget {
  const TodolistWgt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch toàn bộ list — widget này rebuild khi length list thay đổi (thêm/xoá item).
    final todoList = ref.watch(todoListProvider);
    return ListView.builder(
      itemCount: todoList.length, // Số item = độ dài list.
      itemBuilder: (context, index) {
        // Truyền id thay vì cả object để tối ưu rebuild theo pattern "id-based subscription".
        return TodoListItemWdt(id: todoList[index].id);
      },
    );
  }
}
