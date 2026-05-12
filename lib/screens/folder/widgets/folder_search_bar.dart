import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/provider/folder/folder_search.dart';

// Ô search ở màn hình Folders.
// Phải dùng StatefulWidget để giữ TextEditingController local — controller này không thể đặt
// trong provider vì lifecycle gắn với widget tree.
// Source-of-truth keyword vẫn là folderSearchKeywordProvider; controller chỉ là wrapper UI.
class FolderSearchBar extends ConsumerStatefulWidget {
  const FolderSearchBar({super.key});

  @override
  ConsumerState<FolderSearchBar> createState() => _FolderSearchBarState();
}

class _FolderSearchBarState extends ConsumerState<FolderSearchBar> {
  late final TextEditingController _controller; // Controller giữ giá trị input local.

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với giá trị keyword hiện tại trong provider
    // → khi quay lại màn này, text không bị reset.
    _controller = TextEditingController(text: ref.read(folderSearchKeywordProvider));
  }

  @override
  void dispose() {
    _controller.dispose(); // Bắt buộc dispose controller để tránh leak.
    super.dispose();
  }

  // Bắn keyword mới vào provider — provider sẽ trigger filter list folders ở chỗ khác.
  void _onChanged(String value) {
    ref.read(folderSearchKeywordProvider.notifier).setKeyword(value);
  }

  // Nút "x" — clear cả controller và provider state.
  void _onClear() {
    _controller.clear();
    ref.read(folderSearchKeywordProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final keyword = ref.watch(folderSearchKeywordProvider);
    final hasText = keyword.isNotEmpty; // Dùng để bật/tắt nút clear.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15), // Lề ngang 15.
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Nền trắng.
          borderRadius: BorderRadius.circular(12), // Bo 12px.
          // Shadow nhẹ tạo cảm giác search bar nổi trên nền.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02), // Đen 2% — rất mờ.
              blurRadius: 10,
              offset: const Offset(0, 4), // Đổ bóng xuống dưới 4px.
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: "Search Folder Name",
            hintStyle: TextStyle(
              color: Colors.grey.shade400, // Hint xám nhạt.
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search_rounded, // Icon kính lúp bên trái.
              color: Colors.grey.shade400,
              size: 22,
            ),
            // Suffix icon chỉ hiển thị khi có text → tiết kiệm space khi ô trống.
            suffixIcon: hasText
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded, // Icon X để clear.
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                    onPressed: _onClear,
                  )
                : null,
            border: InputBorder.none, // Bỏ viền mặc định của TextField.
            contentPadding: const EdgeInsets.symmetric(vertical: 15), // Padding dọc 15 (cao ~50px).
          ),
        ),
      ),
    );
  }
}
