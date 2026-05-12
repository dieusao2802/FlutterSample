import 'package:flutter/material.dart';

// App bar cho màn hình Folders.
// Layout dùng Stack để title luôn căn giữa tuyệt đối, không bị lệch khi icon trái dài/ngắn.
class FolderAppBar extends StatelessWidget {
  final int folderCount; // Tổng số folder hiện có — hiển thị kèm tiêu đề (vd: "Folders (5)").

  const FolderAppBar({super.key, required this.folderCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Lề ngang 15, dọc 10.
      child: Stack(
        alignment: Alignment.center, // Mặc định mọi children căn giữa Stack.
        children: [
          // Icon menu cố định bên trái — placeholder cho drawer/sidebar trong tương lai.
          Align(
            alignment: Alignment.centerLeft, // Override alignment của Stack — đẩy về trái giữa.
            child: Container(
              padding: const EdgeInsets.all(8), // Padding đều 8px quanh icon.
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200), // Viền xám rất nhạt.
                borderRadius: BorderRadius.circular(10), // Bo 10px.
              ),
              child: const Icon(
                Icons.menu_rounded, // Icon ☰.
                size: 24, // Icon 24px.
                color: Colors.black87, // Đen 87% opacity, dịu hơn pure black.
              ),
            ),
          ),
          // Title nằm giữa Stack — không bị ảnh hưởng bởi kích thước icon hai bên.
          Text(
            "Folders ($folderCount)",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700, // Bold 700.
              color: Color(0xFF1E1E1E), // Đen dịu.
            ),
          ),
        ],
      ),
    );
  }
}
