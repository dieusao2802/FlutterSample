import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/style/text_styles.dart';

// Button chính của app — full-width, bo góc, có sẵn loading state.
// Dùng cho các action chính ở form (Login, Register, Save,...).
class CustomButton extends StatelessWidget {
  final String text; // Nhãn hiển thị trên button.
  final VoidCallback onPressed; // Callback khi user nhấn. Bị disable nếu isLoading=true hoặc isEnable=false.
  final Color? color; // Màu nền tuỳ chỉnh. Null = dùng AppColors.primary.
  final bool isLoading; // true → hiển thị spinner, disable click.
  final bool isEnable; // false → button mờ (alpha 64) và không click được. Lưu ý: default đang là false.

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.isLoading = false,
    this.isEnable = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Chiếm trọn chiều ngang của parent.
      height: 50, // Chiều cao cố định 50px theo chuẩn touch target.
      child: ElevatedButton(
        // Disable click khi đang loading hoặc bị tắt — gán onPressed=null để Flutter tự render style disabled.
        onPressed: isLoading || !isEnable ? null : onPressed,
        style: ElevatedButton.styleFrom(
          // Khi enabled: dùng color truyền vào hoặc primary mặc định.
          // Khi disabled: cùng màu nhưng giảm alpha xuống 64/255 (~25%) để trông mờ.
          backgroundColor: isEnable
              ? (color ?? AppColors.primary)
              : (color ?? AppColors.primary).withAlpha(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Bo 4 góc 12px cho nút mềm mại.
          ),
        ),
        // Loading state → spinner trắng. Bình thường → text.
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white, // Spinner trắng để đối lập với nền primary.
              )
            : Text(
                text,
                style: AppTextStyles.button, // Dùng style chuẩn cho button text.
              ),
      ),
    );
  }
}
