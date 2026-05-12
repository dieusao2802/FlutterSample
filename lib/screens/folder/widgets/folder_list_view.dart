import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/enums/folder_color.dart';
import 'package:todo_list/model/folder.dart';
import 'package:todo_list/provider/folder/folders.dart';
import 'folder_item.dart';

// Danh sách folders ở màn hình Folders.
// Đồng thời chứa logic show dialog Edit/Delete folder — bottom sheet inline trong widget này
// để không phải tách handler ra ngoài (parent đã đủ phức tạp).
class FolderListView extends ConsumerWidget {
  final List<Folder> folders; // Danh sách folder cần render (đã filter ở provider).
  final bool isSearching; // true → khi list rỗng hiển thị message "không tìm thấy" thay vì "chưa có".

  const FolderListView({super.key, required this.folders, this.isSearching = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Empty state: chọn message khác nhau dựa vào isSearching.
    if (folders.isEmpty) {
      final emptyText = isSearching ? 'Không tìm thấy folder' : 'Chưa có folder nào';
      return Center(
        child: Text(
          emptyText,
          style: const TextStyle(
            color: Colors.grey, // Xám trung bình cho empty state.
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10), // Padding dọc 10 ở 2 đầu list.
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        return FolderItem(
          title: folder.name,
          // TODO: hiện hardcode 0 cho journals/todos. Cần wire vào DB count sau.
          journals: 0,
          todos: 0,
          leadingColor: folder.color.color,
          onEdit: (name) {
            _showEditDialog(context, ref, folder); // Mở dialog edit folder.
          },
          onDelete: () {
            _showDeleteDialog(context, ref, folder); // Mở dialog xác nhận xoá.
          },
          onTap: () {
            // TODO: Mở folder
          },
        );
      },
    );
  }

  // Dialog edit folder: cho phép đổi tên + đổi màu.
  // Dùng StatefulBuilder vì dialog cần manage state local (selectedColor, text length)
  // mà không muốn convert cả widget này thành StatefulWidget.
  void _showEditDialog(BuildContext context, WidgetRef ref, Folder folder) {
    final controller = TextEditingController(text: folder.name); // Pre-fill với tên hiện tại.
    var selectedColor = folder.color; // Màu khởi tạo = màu folder hiện tại.

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Đổi tên Folder'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Column tự co theo content.
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: "Nhập tên folder mới"),
                autofocus: true, // Tự focus ô input khi dialog mở.
                // setDialogState rỗng để trigger rebuild → enable/disable nút "Cập nhật".
                onChanged: (data) {
                  setDialogState(() {});
                },
              ),
              const SizedBox(height: 12), // Khoảng 12px giữa input và bảng màu.
              // Bảng màu ngang để chọn FolderColor mới.
              SizedBox(
                height: 45, // Chiều cao bảng màu cố định 45px.
                child: ListView.separated(
                  itemCount: FolderColor.values.length, // Số màu = số phần tử enum.
                  separatorBuilder: (context, index) => const SizedBox(width: 15), // Khoảng 15px giữa các màu.
                  scrollDirection: Axis.horizontal, // Cuộn ngang.
                  itemBuilder: (context, index) {
                    final folderColor = FolderColor.values[index];
                    final isSelected = folderColor == selectedColor;
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = folderColor; // Cập nhật màu chọn + rebuild dialog.
                        });
                      },
                      child: Container(
                        height: 40, // Ô màu vuông 40x40.
                        width: 40,
                        decoration: BoxDecoration(
                          color: folderColor.color, // Màu của FolderColor.
                          shape: BoxShape.circle, // Hình tròn.
                          // Khi selected: thêm glow nhẹ cùng tone màu để nhấn chọn.
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: folderColor.color.withValues(alpha: 0.4), // Tone màu 40% opacity.
                                    blurRadius: 8, // Blur 8px.
                                    offset: const Offset(0, 4), // Lệch xuống 4px.
                                  ),
                                ]
                              : null, // Không selected → không có shadow.
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check, // Dấu ✓ ở giữa khi được chọn.
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              // Disable nút khi input rỗng → onPressed=null.
              // Lưu ý: kiểm tra controller.text.isNotEmpty không trim, nhưng khi submit có trim.
              onPressed: controller.text.isNotEmpty
                  ? () {
                      final newName = controller.text.trim();
                      if (newName.isNotEmpty) {
                        ref
                            .read(foldersProvider.notifier)
                            .updateFolder(folder.copyWith(name: newName, color: selectedColor));
                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: const Text('Cập nhật'),
              style: TextButton.styleFrom(
                disabledForegroundColor: Colors.grey, // Màu chữ khi nút bị disable.
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog xác nhận xoá folder. Cảnh báo kèm cảnh báo cascade: tất cả journal con sẽ bị xoá.
  void _showDeleteDialog(BuildContext context, WidgetRef ref, Folder folder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa Folder'),
        content: Text(
          'Bạn có chắc chắn muốn xóa folder "${folder.name}"? Tất cả các ghi chú bên trong sẽ bị xóa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              ref.read(foldersProvider.notifier).deleteFolder(folder.id); // Gọi notifier xoá.
              Navigator.pop(context); // Đóng dialog.
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red), // Chữ đỏ nhấn mạnh hành động destructive.
            ),
          ),
        ],
      ),
    );
  }
}
