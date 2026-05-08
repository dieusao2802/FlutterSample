import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/model/folder.dart';
import 'package:todo_list/provider/folder/folders.dart';
import 'folder_item.dart';

class FolderListView extends ConsumerWidget {
  final List<Folder> folders;
  final bool isSearching;

  const FolderListView({super.key, required this.folders, this.isSearching = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (folders.isEmpty) {
      final emptyText = isSearching ? 'Không tìm thấy folder' : 'Chưa có folder nào';
      return Center(
        child: Text(emptyText, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        return FolderItem(
          title: folder.name,
          journals: 0,
          todos: 0,
          leadingColor: folder.color.color,
          onEdit: (name) {
            _showEditDialog(context, ref, folder);
          },
          onDelete: () {
            _showDeleteDialog(context, ref, folder);
          },
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Folder folder) {
    final controller = TextEditingController(text: folder.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đổi tên Folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Nhập tên folder mới"),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                ref.read(foldersProvider.notifier).updateFolderName(folder.id, newName);
                Navigator.pop(context);
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Folder folder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa Folder'),
        content: Text(
          'Bạn có chắc chắn muốn xóa folder "${folder.name}"? Tất cả các ghi chú bên trong sẽ bị xóa.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              ref.read(foldersProvider.notifier).deleteFolder(folder.id);
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
