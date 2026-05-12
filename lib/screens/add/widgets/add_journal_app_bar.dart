import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';

// App bar tuỳ biến dùng cho màn hình Add/Edit Journal.
// Cấu trúc: [icon trái] [title ở giữa] [icon phải] + 1 divider mờ phía dưới.
// Cho phép ẩn/disable từng icon độc lập, mặc định nút trái = Close (X) → Navigator.pop,
// nút phải = Check (✓) → Navigator.pop (thường được override để trigger Save).
class AddJournalAppBar extends StatelessWidget {
  final String title; // Tiêu đề ở giữa app bar.
  final bool isShowLeadingIcon; // false → ẩn nút trái, vẫn giữ chỗ để title không lệch.
  final bool isShowTrailingIcon; // false → ẩn nút phải, vẫn giữ chỗ để title không lệch.
  final bool isEnableLeadingIcon; // false → nút trái mờ, không bấm được.
  final bool isEnableTrailingIcon; // false → nút phải mờ (cùng style border xám), không bấm được.
  final VoidCallback? onLeadingPressed; // Callback nút trái. Null → mặc định Navigator.pop.
  final VoidCallback? onTrailingPressed; // Callback nút phải. Null → mặc định Navigator.pop.

  const AddJournalAppBar({
    super.key,
    required this.title,
    this.isShowLeadingIcon = true,
    this.isShowTrailingIcon = true,
    this.isEnableLeadingIcon = true,
    this.isEnableTrailingIcon = true,
    this.onLeadingPressed,
    this.onTrailingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Column tự co theo nội dung, không chiếm toàn bộ chiều cao.
      children: [
        Padding(
          // padding: lề ngang 15px, dọc 10px.
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Dàn đều 3 phần tử: trái, giữa, phải.
            children: [
              // ============================================================
              // Nút trái — ẩn thay bằng SizedBox 48 để title vẫn center.
              // ============================================================
              if (isShowLeadingIcon)
                IconButton(
                  // Disabled → gán onPressed=null để Flutter tự render style disabled.
                  onPressed: isEnableLeadingIcon
                      ? (onLeadingPressed ?? () => Navigator.pop(context))
                      : null,
                  icon: Container(
                    padding: const EdgeInsets.all(8), // Padding đều 8px quanh icon.
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200), // Viền xám rất nhạt 200.
                      borderRadius: BorderRadius.circular(10), // Bo 4 góc 10px.
                    ),
                    child: Icon(
                      Icons.close, // Icon X.
                      size: 20, // Icon 20px.
                      // Enabled = đen 87% (#000000DD ~ Colors.black87). Disabled = xám nhạt 400.
                      color: isEnableLeadingIcon ? Colors.black87 : Colors.grey.shade400,
                    ),
                  ),
                )
              else
                const SizedBox(width: 48), // 48 = chiều rộng IconButton mặc định, giữ title cân.

              // ============================================================
              // Title ở giữa.
              // ============================================================
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18, // 18px - cỡ chữ chuẩn app bar.
                  fontWeight: FontWeight.w700, // Bold 700.
                  color: Color(0xFF1E1E1E), // Đen gần như tuyệt đối, dịu hơn pure black.
                ),
              ),

              // ============================================================
              // Nút phải — viền và màu icon đổi theo enable: primary khi bật, grey khi tắt.
              // ============================================================
              if (isShowTrailingIcon)
                IconButton(
                  onPressed: isEnableTrailingIcon
                      ? (onTrailingPressed ?? () => Navigator.pop(context))
                      : null,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        // Enabled = viền primary. Disabled = viền xám.
                        color: isEnableTrailingIcon ? AppColors.primary : Colors.grey.shade200,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.check, // Icon ✓.
                      size: 20,
                      // Enabled = primary. Disabled = xám 400.
                      color: isEnableTrailingIcon ? AppColors.primary : Colors.grey.shade400,
                    ),
                  ),
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
        // Divider mỏng tách app bar khỏi body.
        Divider(
          height: 1, // Chiều cao tổng của Divider = 1px.
          thickness: 1, // Độ dày đường kẻ = 1px.
          color: Colors.grey.shade200, // Xám rất nhạt.
        ),
      ],
    );
  }
}
