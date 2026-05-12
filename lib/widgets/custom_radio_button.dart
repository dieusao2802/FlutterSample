import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/style/text_styles.dart';

// Radio button generic — dùng cho group chọn 1 trong nhiều option.
// Generic <T> cho phép value/groupValue là bất kỳ kiểu nào (enum, String, int,...).
// Toàn bộ vùng row đều click được (không chỉ ô tròn) nhờ wrap bằng InkWell.
class CustomRadioButton<T> extends StatelessWidget {
  final T value; // Giá trị đại diện cho option này.
  final T groupValue; // Giá trị hiện đang được chọn trong cả group. Nếu value == groupValue thì option này được selected.
  final String label; // Text hiển thị bên cạnh ô tròn.
  final ValueChanged<T?> onChanged; // Callback khi user chọn option này.

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định trạng thái selected dựa trên so sánh value và groupValue.
    final bool isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value), // Tap toàn row → trigger onChanged với value của option này.
      borderRadius: BorderRadius.circular(8), // Bo 8px cho hiệu ứng ripple gọn gàng khi tap.
      child: Padding(
        // padding nội dung: dọc 8px (lề trên/dưới), ngang 4px (sát hai bên).
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            // Ô tròn ngoài — đổi viền sang primary khi selected.
            Container(
              height: 20, // Chiều cao ô tròn 20px.
              width: 20, // Chiều rộng ô tròn 20px.
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Hình tròn (alternative cho borderRadius).
                border: Border.all(
                  // Selected: primary. Không selected: xám.
                  color: isSelected ? AppColors.primary : Colors.grey,
                  width: 2, // Độ dày viền 2px.
                ),
              ),
              // Chấm tròn ở giữa chỉ render khi selected.
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10, // Chấm trong nhỏ hơn ô ngoài — chiều cao 10px.
                        width: 10, // Chấm trong — chiều rộng 10px.
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary, // Chấm cùng màu với viền (primary).
                        ),
                      ),
                    )
                  : null, // Không selected → không có chấm.
            ),
            const SizedBox(width: 12), // Khoảng cách 12px giữa ô tròn và label.
            Text(
              label,
              style: AppTextStyles.body, // Dùng style body chuẩn.
            ),
          ],
        ),
      ),
    );
  }
}
