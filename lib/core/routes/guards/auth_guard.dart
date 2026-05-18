import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/routes/app_router.gr.dart';
import 'package:todo_list/provider/auth/auth_status.dart';

/// Guard kiểm tra trạng thái đăng nhập.
/// Tách biệt ra file riêng để dễ dàng quản lý và tái sử dụng.
class AuthGuard extends AutoRouteGuard {
  final Ref _ref;

  AuthGuard(this._ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final status = _ref.read(authProvider);

    if (status == AuthStatus.authenticated) {
      resolver.next(true);
    } else if (status == AuthStatus.unauthenticated) {
      // Cancel navigation gốc (tránh treo resolver) rồi replace sang Login
      resolver.next(false);
      router.replace(const LoginRoute());
    } else {
      // Nếu là unknown (đang check), cho phép đi tiếp vì SplashPage sẽ lo việc chuyển hướng
      // hoặc giữ lại cho đến khi có trạng thái chính thức.
      resolver.next(true);
    }
  }
}
