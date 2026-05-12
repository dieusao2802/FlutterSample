import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/core/routes/app_routes.dart';
import 'package:todo_list/core/utils/validation_utils.dart';
import 'package:todo_list/gen/strings.g.dart';
import 'package:todo_list/widgets/custom_button.dart';
import 'package:todo_list/widgets/custom_text_field.dart';

import '../../provider/auth/login.dart';
import '../../provider/auth/register.dart';
import '../../provider/locale/locale.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onInputChanged);
    _passwordController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.removeListener(_onInputChanged);
    _passwordController.removeListener(_onInputChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isButtonEnabled {
    return _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: _LanguageToggle(currentCode: ref.watch(localeControllerProvider)),
                ),
                const SizedBox(height: 32),
                Text(t.auth.login.title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(t.auth.login.subtitle, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 48),
                CustomTextField(
                  label: t.auth.login.emailLabel,
                  hint: t.auth.login.emailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationUtils.validateEmail,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: t.auth.login.passwordLabel,
                  hint: t.auth.login.passwordHint,
                  isPassword: true,
                  controller: _passwordController,
                  validator: ValidationUtils.validatePassword,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: Text(
                      t.auth.login.forgotPassword,
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (loginState.isError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      loginState.errorMessage,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                CustomButton(
                  text: t.auth.login.loginButton,
                  isLoading: loginState.isBusy,
                  isEnable: _isButtonEnabled,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await ref
                          .read(loginProvider.notifier)
                          .login(_emailController.text, _passwordController.text);
                      if (success && context.mounted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      }
                    }
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(t.auth.login.noAccount),
                    TextButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, AppRoutes.register);
                        if (!context.mounted) return;
                        final registeredData = ref.read(registerProvider).registeredData;
                        if (registeredData != null) {
                          _emailController.text = registeredData.email;
                          _passwordController.text = registeredData.password;
                        }
                      },
                      child: Text(
                        t.auth.login.register,
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                    child: Text(
                      t.auth.login.loginWithoutAccount,
                      style: const TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageToggle extends ConsumerWidget {
  final String currentCode;

  const _LanguageToggle({required this.currentCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(ref, AppLocale.vi, 'VI'),
          _buildItem(ref, AppLocale.en, 'EN'),
        ],
      ),
    );
  }

  Widget _buildItem(WidgetRef ref, AppLocale locale, String label) {
    final isActive = currentCode == locale.languageCode;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: isActive
          ? null
          : () => ref.read(localeControllerProvider.notifier).setLocale(locale),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
