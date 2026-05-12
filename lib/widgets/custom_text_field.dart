import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/style/text_styles.dart';

// TextField chuẩn của app — bao gồm label phía trên, ô input bo góc 12,
// validator inline, và đổi viền theo trạng thái (default/focus/error).
// Dùng cho mọi form input (Login, Register, Forgot password,...).
class CustomTextField extends StatelessWidget {
  final String label; // Tiêu đề hiển thị phía trên ô input.
  final String hint; // Placeholder khi ô input trống.
  final bool isPassword; // true → che ký tự nhập (obscureText).
  final TextEditingController? controller; // Controller để đọc/ghi giá trị từ bên ngoài.
  final String? Function(String?)? validator; // Hàm validate — return null nếu hợp lệ, return message nếu lỗi.
  final TextInputType? keyboardType; // Loại bàn phím (text, email, number,...). Tương đương android:inputType.
  final TextInputAction? textInputAction; // Hành động nút bàn phím (next/done/...). Tương đương android:imeOptions.

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // Children căn lề trái → label và input cùng align bên trái.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label phía trên — in đậm, dùng style bodySmall.
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimary, // Màu text chính (đen/xám đậm).
            fontWeight: FontWeight.bold, // In đậm để nổi bật label.
          ),
        ),
        const SizedBox(height: 8), // Khoảng cách 8px giữa label và ô input.
        TextFormField(
          controller: controller, // Controller bên ngoài (có thể null nếu không cần đọc value).
          obscureText: isPassword, // true cho password → che ký tự bằng ●.
          validator: validator, // Hàm validate inline.
          keyboardType: keyboardType, // Loại bàn phím hiển thị.
          textInputAction: textInputAction, // Hành động nút Enter trên bàn phím.
          // Validate ngay khi user tương tác → feedback tức thời, không cần submit.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint, // Placeholder text.
            hintStyle: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey, // Hint màu xám để phân biệt với text đã nhập.
            ),
            filled: true, // Bật fill background.
            fillColor: AppColors.white, // Nền ô input — trắng.
            // padding bên trong ô input: ngang 12px, dọc 12px.
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

            // ============================================================
            // 5 border variants tương ứng các trạng thái khác nhau của TextFormField.
            // Tất cả đều bo 12px để đồng bộ visual.
            // ============================================================

            // Border mặc định (rarely shown, là fallback).
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.textSecondary, // Màu border mặc định.
                width: 1, // Độ dày 1px.
              ),
            ),
            // Border khi ô đang enabled nhưng không focus → xám nhạt.
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            // Border khi user đang focus → primary, dày hơn (1.5px) để nhấn mạnh.
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            // Border khi có lỗi validation → đỏ.
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            // Border khi vừa focus vừa có lỗi → đỏ dày hơn (1.5px).
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            // Style cho message lỗi hiển thị dưới ô input.
            errorStyle: const TextStyle(
              color: AppColors.error, // Màu chữ đỏ.
              fontSize: 12, // Size nhỏ hơn body.
            ),
          ),
        ),
      ],
    );
  }
}
