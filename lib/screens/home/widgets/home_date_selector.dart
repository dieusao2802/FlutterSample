import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/core/constants/app_colors.dart';

// Selector hiển thị ngày hiện tại + carousel 10 ngày để chọn.
// Layout:
//   [Title ngày dạng "11 May 2026, Thứ Hai" | nút mở DatePicker đầy đủ]
//   [Carousel 10 thẻ ngày: ngày trước hôm nay, hôm nay, 8 ngày kế tiếp]
// State giữ local. Default selected = index 1 (= hôm nay), index 0 = hôm qua.
class HomeDateSelector extends StatefulWidget {
  const HomeDateSelector({super.key});

  @override
  State<HomeDateSelector> createState() => _HomeDateSelectorState();
}

class _HomeDateSelectorState extends State<HomeDateSelector> {
  // Index của ngày đang được chọn trong _dates. Default 1 = hôm nay (vì index 0 là hôm qua).
  int _selectedDateIndex = 1;

  // Danh sách 10 ngày cố định: từ hôm qua đến 8 ngày kế tiếp.
  // Lưu ý: List được tạo 1 lần khi state init → nếu app chạy qua nửa đêm, dates KHÔNG tự refresh.
  final List<DateTime> _dates = List.generate(
    10,
    (index) => DateTime.now().add(Duration(days: index - 1)),
  );

  @override
  Widget build(BuildContext context) {
    final selectedDate = _dates[_selectedDateIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Children align trái.
      children: [
        // ============================================================
        // HEADER: title ngày + nút mở DatePicker.
        // ============================================================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Lề ngang 20.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat('dd MMMM').format(selectedDate), // VD: "11 May".
                        style: const TextStyle(
                          fontSize: 24, // Cỡ lớn để nhấn ngày.
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('yyyy').format(selectedDate), // Năm tách riêng.
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600, // Xám đậm vừa.
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down, // Mũi tên xuống (gợi ý có thể mở dropdown).
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Hardcode "7 Journals today" — cần thay bằng count thực tế từ DB sau.
                  Text(
                    "7 Journals today",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              // Nút mở DatePicker chính — chưa wire onTap.
              Container(
                padding: const EdgeInsets.all(10), // Padding đều 10px.
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3E5C), // Xanh đậm navy (riêng cho nút lịch).
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // ============================================================
        // CAROUSEL: mỗi thẻ là 1 ngày.
        // ============================================================
        SizedBox(
          height: 90, // Chiều cao thẻ ngày 90px.
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: _dates.length,
            itemBuilder: (context, index) {
              final date = _dates[index];
              final isSelected = _selectedDateIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedDateIndex = index),
                // AnimatedContainer cho hiệu ứng đổi màu mượt 200ms khi chuyển chọn.
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 65, // Chiều rộng thẻ 65px.
                  margin: const EdgeInsets.symmetric(horizontal: 5), // Khoảng cách 5px giữa các thẻ.
                  decoration: BoxDecoration(
                    // Selected = primary. Còn lại = trắng.
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03), // Đen 3% — shadow rất nhẹ.
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc.
                    children: [
                      Text(
                        DateFormat('d').format(date), // Day of month (1-31), không zero-pad.
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // Selected = trắng. Còn lại = đen 87%.
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEE').format(date), // Day of week abbreviated (Mon/Tue/...).
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          // Selected = trắng 70%. Còn lại = xám 500.
                          color: isSelected ? Colors.white70 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
