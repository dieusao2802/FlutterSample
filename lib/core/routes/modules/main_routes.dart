import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/routes/app_router.gr.dart';
import '../guards/auth_guard.dart';

/// Danh sách các route chính của ứng dụng (đã đăng nhập).
/// Tất cả các route ở đây đều được bảo vệ bởi [AuthGuard].
abstract class MainRoutes {
  static List<AutoRoute> getRoutes(Ref ref) {
    return [
      AutoRoute(path: '/home', page: HomeRoute.page, guards: [AuthGuard(ref)]),
      AutoRoute(path: '/add-task', page: AddJournalRoute.page, guards: [AuthGuard(ref)]),
      AutoRoute(path: '/add-folder', page: AddFolderRoute.page, guards: [AuthGuard(ref)]),
    ];
  }
}
