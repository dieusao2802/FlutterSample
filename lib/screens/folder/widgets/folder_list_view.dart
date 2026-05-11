import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/enums/folder_color.dart';
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
          onTap: () {
            // TODO: Mở folder
          },
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Folder folder) {
    final controller = TextEditingController(text: folder.name);
    var selectedColor = folder.color;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Đổi tên Folder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: "Nhập tên folder mới"),
                autofocus: true,
                onChanged: (data) {
                  setDialogState(() {});
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 45,
                child: ListView.separated(
                  itemCount: FolderColor.values.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 15),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final folderColor = FolderColor.values[index];
                    final isSelected = folderColor == selectedColor;
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = folderColor;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: folderColor.color,
                          shape: BoxShape.circle,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: folderColor.color.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            TextButton(
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
              style: TextButton.styleFrom(disabledForegroundColor: Colors.grey),
            ),
          ],
        ),
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
