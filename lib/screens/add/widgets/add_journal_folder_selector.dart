import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/provider/folder/folders.dart';
import 'package:todo_list/provider/journal/add_journal.dart';

// Row chọn Folder cho Journal đang tạo.
// - Khi chưa chọn: hiển thị icon xám + text "Choose Folder".
// - Khi đã chọn: icon mang màu của folder + tên folder.
// Tap mở BottomSheet danh sách folders (đọc từ foldersProvider).
class AddJournalFolderSelector extends ConsumerWidget {
  const AddJournalFolderSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dùng .select() để widget này chỉ rebuild khi field selectedFolder thay đổi,
    // không bị trigger bởi các field khác trong AddJournalState (title, content,...).
    final selectedFolder = ref.watch(addJournalProvider.select((s) => s.selectedFolder));
    final notifier = ref.watch(addJournalProvider.notifier);

    return GestureDetector(
      onTap: () => _showFolderSelection(context, ref, notifier), // Tap → mở bottom sheet chọn folder.
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Lề ngoài 20/10.
        padding: const EdgeInsets.symmetric(vertical: 15), // Padding dọc 15 (ngang để 0 để border kéo full).
        decoration: BoxDecoration(
          // Chỉ có 2 viền trên/dưới (kiểu list item phân tách), không có viền 2 bên.
          border: Border(
            top: BorderSide(color: Colors.grey.shade100), // Viền trên xám rất nhạt 100.
            bottom: BorderSide(color: Colors.grey.shade100), // Viền dưới xám rất nhạt 100.
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_outlined, // Icon folder mở.
              // Đổi màu icon theo folder đã chọn, hoặc xám nếu chưa chọn.
              color: selectedFolder != null ? selectedFolder.color.color : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 15), // Khoảng cách 15px giữa icon và text.
            Expanded(
              // Expanded để text chiếm hết space giữa icon trái và icon chevron phải.
              child: Text(
                selectedFolder?.name ?? "Choose Folder", // Tên folder hoặc placeholder.
                style: TextStyle(
                  fontSize: 16,
                  // Đã chọn = đen dịu. Chưa chọn = xám (như placeholder).
                  color: selectedFolder != null ? const Color(0xFF1E1E1E) : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded, // Mũi tên > biểu thị tappable / mở thêm.
              color: Colors.grey.shade400, // Xám nhạt vừa phải.
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // Mở BottomSheet hiển thị danh sách folders để user chọn.
  // foldersProvider là AsyncValue → handle đủ 3 state: data / loading / error.
  void _showFolderSelection(BuildContext context, WidgetRef ref, AddJournal notifier) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // Bo góc TRÊN của bottom sheet, đáy giữ vuông để dính bottom màn hình.
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Wrap bằng Consumer để bottom sheet tự rebuild khi list folders thay đổi
        // (vd: user vừa thêm folder mới ở màn khác).
        return Consumer(
          builder: (context, ref, child) {
            final foldersAsync = ref.watch(foldersProvider);
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20), // Padding dọc 20.
              child: Column(
                mainAxisSize: MainAxisSize.min, // Column tự co theo nội dung.
                crossAxisAlignment: CrossAxisAlignment.stretch, // Children chiếm full chiều ngang.
                children: [
                  const Text(
                    "Select Folder",
                    textAlign: TextAlign.center, // Title căn giữa.
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15), // Khoảng cách 15px giữa title và list.
                  // 3 state của AsyncValue: data / loading / error.
                  foldersAsync.when(
                    data: (folders) {
                      if (folders.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                          child: Text("No folders found", textAlign: TextAlign.center),
                        );
                      }
                      // Flexible + shrinkWrap để list cuộn được mà sheet không tràn toàn màn hình.
                      return Flexible(
                        child: ListView.builder(
                          shrinkWrap: true, // List tự co theo content, không greedy.
                          itemCount: folders.length,
                          itemBuilder: (context, index) {
                            final folder = folders[index];
                            return ListTile(
                              leading: Icon(
                                Icons.folder,
                                color: folder.color.color, // Icon mang màu của folder.
                              ),
                              title: Text(folder.name),
                              onTap: () {
                                notifier.updateFolder(folder); // Cập nhật folder đã chọn.
                                Navigator.pop(context); // Đóng bottom sheet.
                              },
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(), // Spinner khi đang load.
                    ),
                    error: (e, st) => Center(
                      child: Text("Error: $e"), // Hiển thị message lỗi đơn giản.
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
