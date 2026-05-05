import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/style/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final bool isLoading;
  final bool isEnable;

  const CustomButton({super.key, required this.text, required this.onPressed, this.color, this.isLoading = false, this.isEnable = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading || !isEnable ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnable ? (color ?? AppColors.primary) : (color ?? AppColors.primary).withAlpha(64),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(text, style: AppTextStyles.button),
      ),
    );
  }
}
