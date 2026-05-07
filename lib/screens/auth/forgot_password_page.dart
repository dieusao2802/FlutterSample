import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/provider/auth/forgot_provider.dart';
import 'package:todo_list/style/text_styles.dart';
import 'package:todo_list/widgets/custom_button.dart';
import 'package:todo_list/widgets/custom_text_field.dart';

import '../../core/utils/validation_utils.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgotViewState();
}

class _ForgotViewState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onInputChanged);
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotProvider);

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
              const Text('Enter your email address and we will send you instructions to reset your password.', style: AppTextStyles.bodySmall),
              const SizedBox(height: 40),
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: ValidationUtils.validateEmail,
              ),
              if (state.isError) ...[const SizedBox(height: 12), Text(state.errorMessage, style: const TextStyle(color: Colors.red, fontSize: 13))],
              const SizedBox(height: 40),
              CustomButton(
                text: 'Send Instructions',
                isEnable: ValidationUtils.validateEmail(_emailController.text) == null,
                isLoading: state.isBusy,
                onPressed: _handleForgotPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final success = await ref.read(forgotProvider.notifier).sendResetNotification(email);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thông tin tài khoản đã được gửi qua thông báo')));
    }
  }
}
