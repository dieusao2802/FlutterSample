import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/navigation/global_navigator.dart';

import 'package:todo_list/provider/auth/auth_status.dart';

// Import Generated Routes
import 'package:todo_list/core/routes/app_router.gr.dart';

// Import Modules & Guards
import 'modules/auth_routes.dart';
import 'modules/main_routes.dart';

/// CLASS CẤU HÌNH CHÍNH CỦA AUTOROUTER (ROOT ROUTER)
///
/// Đối với dự án lớn, chúng ta chia nhỏ routes thành các module:
/// 1. [AuthRoutes]: Login, Register...
/// 2. [MainRoutes]: Home, Task Management (Protected)...
/// 3. [Guards]: Xử lý phân quyền (AuthGuard, AdminGuard...)
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final Ref _ref;

  AppRouter(this._ref) {
    // Đăng ký router instance vào GlobalNavigator để điều hướng không cần context
    GlobalNavigator.router = this;

    // Lắng nghe trạng thái auth để re-evaluate guards tự động
    _ref.listen(authProvider, (previous, next) {
      if (previous != next) {
        reevaluateGuards();
      }
    });
  }

  @override
  List<AutoRoute> get routes => [
    // --- 1. STARTUP ROUTE ---
    AutoRoute(path: '/', page: SplashRoute.page, initial: true),

    // --- 2. AUTH MODULE ---
    ...AuthRoutes.routes,

    // --- 3. MAIN APP MODULE (PROTECTED) ---
    ...MainRoutes.getRoutes(_ref),

    // --- 4. OTHERS/DEMO ---
    AutoRoute(path: '/demo-resources', page: DemoResourcesRoute.page),

    // --- 5. WILDCARD (404) ---
    // Có thể thêm trang 404 ở đây nếu cần:
    // RedirectRoute(path: '*', redirectTo: '/'),
  ];
}

/// Provider để cung cấp AppRouter duy nhất (Singleton-like) cho toàn bộ ứng dụng
final appRouterProvider = Provider((ref) => AppRouter(ref));
