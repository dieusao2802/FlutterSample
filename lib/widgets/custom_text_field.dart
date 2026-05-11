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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label in đậm phía trên ô input.
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          // Validate ngay khi user tương tác → feedback tức thời, không cần submit.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

            // 5 border variants tương ứng các trạng thái khác nhau của TextFormField.
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textSecondary, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
