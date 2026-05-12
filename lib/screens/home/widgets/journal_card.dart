import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';

// Card hiển thị 1 Journal trong danh sách Home.
// Layout:
//   [thumbnail 80x80] [title + desc + tags]
//   ─────── (divider) ───────
//   [icon thư viện | images] [icon folder | category]  →  [icon clock | time]
class JournalCard extends StatelessWidget {
  final String title; // Tiêu đề journal.
  final String desc; // Mô tả ngắn (lines giới hạn 2 trong UI để tránh card cao quá).
  final List<String> tags; // Danh sách tag — render thành pill ở dưới desc.
  final String images; // Text mô tả số ảnh (vd: "6 Images"). Lưu ý: là String, không phải int.
  final String category; // Tên folder/category — hiển thị ở footer.
  final String time; // Giờ Journal (vd: "7:24 PM") — hiển thị ở góc phải footer.

  const JournalCard({
    super.key,
    required this.title,
    required this.desc,
    required this.tags,
    required this.images,
    required this.category,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20), // Khoảng 20px giữa các card.
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Bo 16px cho card mềm.
        // Shadow rất nhẹ tạo cảm giác card nổi trên nền.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02), // Đen 2%.
            blurRadius: 10,
            offset: const Offset(0, 4), // Đổ bóng xuống 4px.
          ),
        ],
      ),
      child: Column(
        children: [
          // ============================================================
          // PHẦN TRÊN: thumbnail + nội dung text.
          // ============================================================
          Padding(
            padding: const EdgeInsets.all(12), // Padding đều 12px.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Children align top.
              children: [
                // Placeholder ảnh — chưa wire ảnh thật từ DB. Sẽ thay bằng Image.file/Image.network sau.
                Container(
                  width: 80, // Thumbnail vuông 80x80.
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // Nền xám rất nhạt.
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.image_outlined, // Icon placeholder ảnh.
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 15), // Khoảng 15px giữa thumbnail và text.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.4, // Line-height 1.4 cho dễ đọc.
                        ),
                        maxLines: 2, // Giới hạn tối đa 2 dòng.
                        overflow: TextOverflow.ellipsis, // Tràn dòng → "...".
                      ),
                      const SizedBox(height: 10),
                      // Wrap để tag tự xuống dòng nếu chiều ngang không đủ.
                      Wrap(
                        spacing: 8, // Khoảng 8px giữa các tag.
                        children: tags.map((tag) => _JournalTag(label: tag)).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1), // Divider 1px tách 2 phần.
          // ============================================================
          // FOOTER: metadata (số ảnh / category / time).
          // ============================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _JournalFooterItem(icon: Icons.photo_library_outlined, label: images),
                const SizedBox(width: 15), // Khoảng 15px giữa images và category.
                _JournalFooterItem(icon: Icons.folder_open_outlined, label: category),
                const Spacer(), // Đẩy item time về tận góc phải.
                _JournalFooterItem(icon: Icons.access_time_rounded, label: time),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Pill nhỏ cho mỗi tag — nền màu primary, text trắng.
class _JournalTag extends StatelessWidget {
  final String label; // Nội dung tag.

  const _JournalTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Padding ngang 12, dọc 4.
      decoration: BoxDecoration(
        color: AppColors.primary, // Nền primary.
        borderRadius: BorderRadius.circular(20), // Bo 20px cho hình pill.
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10, // Cỡ nhỏ 10px cho tag.
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Item ở footer = icon + label, dùng cho 3 ô (images / category / time).
class _JournalFooterItem extends StatelessWidget {
  final IconData icon; // Icon đại diện loại metadata.
  final String label; // Text bên cạnh icon.

  const _JournalFooterItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14, // Icon nhỏ 14px cho footer.
          color: Colors.grey.shade500,
        ),
        const SizedBox(width: 5), // Khoảng 5px giữa icon và label.
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
