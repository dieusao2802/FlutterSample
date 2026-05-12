import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/provider/journal/add_journal.dart';

// Toolbar nổi ở đáy màn hình Add Journal, chứa các icon "đính kèm media" và action khác.
// - Camera / Image đã wire vào notifier (chụp ảnh / chọn từ thư viện).
// - Label / Music / Video / More: chưa có handler (placeholder cho tính năng tương lai).
class AddJournalToolbar extends ConsumerWidget {
  const AddJournalToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy notifier của addJournalProvider để gọi method takePhoto / pickImages.
    // .watch() khiến widget rebuild khi state thay đổi — có thể đổi sang .read() vì toolbar
    // không dùng state trực tiếp, chỉ gọi action.
    final notifier = ref.watch(addJournalProvider.notifier);

    return Container(
      // padding nội dung: ngang 20px (lề trái/phải), dọc 15px (lề trên/dưới).
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white, // Nền trắng để toolbar nổi bật trên background xám.
        // Bo 2 góc TRÊN, 2 góc dưới giữ vuông → toolbar dính vào đáy màn hình.
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), // Góc trên trái bo 20px.
          topRight: Radius.circular(20), // Góc trên phải bo 20px.
        ),
        // Shadow hắt LÊN trên (offset Y âm) → cảm giác toolbar "trồi lên" khỏi nền.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // Đen 5% opacity — shadow rất nhẹ.
            blurRadius: 10, // Độ blur 10px cho mép shadow mềm mại.
            offset: const Offset(0, -4), // Lệch X=0, Y=-4 (đi lên 4px).
          ),
        ],
      ),
      child: Row(
        // Dàn đều icon với khoảng cách bằng nhau giữa các icon, KHÔNG có khoảng ở 2 mép.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon máy ảnh → mở camera chụp ảnh đính kèm vào Journal.
          _buildToolIcon(Icons.camera_alt_outlined, onTap: () => notifier.takePhoto()),
          // Icon ảnh → mở thư viện ảnh để chọn nhiều ảnh.
          _buildToolIcon(Icons.image_outlined, onTap: () => notifier.pickImages()),
          // Icon nhãn → chưa wire (tính năng tag sẽ làm sau).
          _buildToolIcon(Icons.label_outline_rounded),
          // Icon nốt nhạc → chưa wire (đính kèm audio).
          _buildToolIcon(Icons.music_note_outlined),
          // Icon camera quay → chưa wire (đính kèm video).
          _buildToolIcon(Icons.videocam_outlined),
          // Icon 3 chấm → chưa wire (more actions).
          _buildToolIcon(Icons.more_horiz_rounded),
        ],
      ),
    );
  }

  // Builder cho 1 icon trong toolbar.
  // onTap null → icon vẫn render nhưng GestureDetector không phản hồi tap.
  Widget _buildToolIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, // Callback khi user tap vào icon. Null → vô hiệu hoá tap.
      child: Icon(
        icon, // Icon hiển thị (truyền từ ngoài vào).
        color: Colors.grey.shade600, // Màu xám đậm — không quá nổi để cân bằng visual.
        size: 26, // Kích thước icon 26px.
      ),
    );
  }
}
