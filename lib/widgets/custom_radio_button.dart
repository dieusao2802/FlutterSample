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
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            // Ô tròn ngoài — đổi viền sang primary khi selected.
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey,
                  width: 2,
                ),
              ),
              // Chấm tròn ở giữa chỉ render khi selected.
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}
