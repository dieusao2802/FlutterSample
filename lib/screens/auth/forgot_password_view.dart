import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/style/text_styles.dart';
import 'package:todo_list/widgets/custom_button.dart';
import 'package:todo_list/widgets/custom_text_field.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Reset Password', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              const Text(
                'Enter your email address and we will send you instructions to reset your password.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 40),
              const CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Send Instructions',
                onPressed: () {
                  // TODO: Implement forgot password logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reset link sent to your email')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
