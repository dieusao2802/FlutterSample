import 'package:flutter/material.dart';

// Card đại diện cho 1 folder trong danh sách Folders.
// Layout: [stripe màu bên trái 5px] [icon folder] [title + 2 chỉ số] [nút edit] [nút delete].
// IntrinsicHeight để stripe màu kéo dài bằng chiều cao card (theo content).
class FolderItem extends StatelessWidget {
  final Color leadingColor; // Màu stripe bên trái — biểu trưng cho folder.
  final String title; // Tên folder.
  final int journals; // Số journals trong folder, hiển thị trong dòng phụ.
  final int todos; // Số todos trong folder (concept tách biệt với Journal), hiển thị trong dòng phụ.
  final void Function(String) onEdit; // Callback nút edit, nhận title hiện tại để pre-fill dialog.
  final VoidCallback onDelete; // Callback nút delete.
  final VoidCallback onTap; // Callback khi tap toàn bộ card (mở chi tiết folder).

  const FolderItem({
    super.key,
    required this.leadingColor,
    required this.title,
    required this.journals,
    required this.todos,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Tap toàn card → mở chi tiết.
      borderRadius: BorderRadius.circular(12), // Bo 12px cho ripple effect đẹp.
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), // Lề ngoài 15/8.
        decoration: BoxDecoration(
          color: Colors.white, // Nền card trắng.
          borderRadius: BorderRadius.circular(12), // Bo 12px khớp với InkWell.
          // Shadow nhẹ cho hiệu ứng card nổi trên nền.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02), // Đen 2% — rất mờ.
              blurRadius: 10, // Blur 10px cho mép shadow mềm.
              offset: const Offset(0, 4), // Lệch Y=4 (đổ bóng xuống dưới 4px).
            ),
          ],
        ),
        // IntrinsicHeight để Container stripe màu (width=5) tự dãn theo chiều cao card.
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Stripe màu dọc bên trái — chỉ bo 2 góc bên trái để khớp với card.
              Container(
                width: 5, // Stripe rộng 5px.
                decoration: BoxDecoration(
                  color: leadingColor, // Màu folder.
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12), // Bo trên trái khớp card.
                    bottomLeft: Radius.circular(12), // Bo dưới trái khớp card.
                  ),
                ),
              ),
              const SizedBox(width: 15), // Khoảng 15px giữa stripe và icon folder.
              const Icon(
                Icons.folder_open_rounded, // Icon folder mở (rounded variant).
                color: Colors.grey, // Xám trung bình.
                size: 30, // Icon 30px - to hơn các icon khác để nhấn mạnh.
              ),
              const SizedBox(width: 15),
              Expanded(
                // Expanded để vùng text chiếm hết space giữa icon và 2 nút phải.
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15), // Padding dọc 15.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Text align trái.
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600, // Semi-bold 600.
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(height: 5), // Khoảng 5px giữa title và row chỉ số.
                      // 2 chỉ số đặt cạnh nhau: số Journals và số Todos trong folder.
                      Row(
                        children: [
                          Text(
                            "Journals: $journals",
                            style: TextStyle(
                              color: Colors.grey.shade500, // Xám 500.
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 20), // Khoảng 20px giữa 2 chỉ số.
                          Text(
                            "Todo: $todos",
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined, // Icon bút edit.
                  size: 20,
                  color: Colors.grey,
                ),
                // Truyền title hiện tại lên parent để có thể pre-fill ô input edit.
                onPressed: () => onEdit(title),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded, // Icon thùng rác (outlined).
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: onDelete,
              ),
              const SizedBox(width: 5), // Lề phải 5px để cách mép card.
            ],
          ),
        ),
      ),
    );
  }
}
