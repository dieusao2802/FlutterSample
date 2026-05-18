import 'package:auto_route/auto_route.dart';
import 'package:todo_list/core/routes/app_router.gr.dart';

/// Danh sách các route liên quan đến xác thực (Authentication).
/// Việc chia nhỏ giúp file app_router.dart không bị phình to.
abstract class AuthRoutes {
  static final routes = [
    AutoRoute(path: '/login', page: LoginRoute.page),
    AutoRoute(path: '/register', page: RegisterRoute.page),
    AutoRoute(path: '/forgot-password', page: ForgotPasswordRoute.page),
  ];
}
