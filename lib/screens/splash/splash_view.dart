import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/core/routes/app_router.gr.dart';
import 'package:todo_list/domain/usecases/auth/check_session_usecase.dart';
import 'package:todo_list/provider/auth/auth_status.dart';
import 'package:todo_list/style/text_styles.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
    _checkSession();
  }

  /// Splash chỉ chịu trách nhiệm:
  /// 1. Hiển thị UI loading ≥ 2s.
  /// 2. Gọi check session.
  /// 3. Cập nhật [AuthNotifier] — redirect của go_router lo chuyển trang.
  Future<void> _checkSession() async {
    try {
      // Đợi cả 2 tác vụ: check session và delay tối thiểu 2s
      final results = await Future.wait([
        locator<CheckSessionUseCase>()(),
        Future.delayed(const Duration(seconds: 2)),
      ]).timeout(const Duration(seconds: 3)); // Tránh treo vĩnh viễn nếu provider lỗi

      if (!mounted) return;

      final isLoggedIn = results[0] != null;
      final authNotifier = ref.read(authProvider.notifier);

      if (isLoggedIn) {
        authNotifier.setAuthenticated();
        // Để Riverpod cập nhật state xong xuôi rồi mới chuyển trang
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.router.replace(const HomeRoute());
        });
      } else {
        authNotifier.setUnauthenticated();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.router.replace(const LoginRoute());
        });
      }
    } catch (e) {
      // Nếu có lỗi, đẩy về màn hình Login để user thử lại
      debugPrint("Splash Error: $e");
      if (mounted) {
        ref.read(authProvider.notifier).setUnauthenticated();
        context.router.replace(const LoginRoute());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: AppColors.white),
            const SizedBox(height: 16),
            Text('TODO APP', style: AppTextStyles.h1.copyWith(color: AppColors.white)),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
