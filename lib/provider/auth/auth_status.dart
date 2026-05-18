import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_status.g.dart';

/// Trạng thái xác thực toàn cục — go_router redirect dựa vào enum này.
/// - [unknown]: đang kiểm tra session (lúc cold start, splash chạy).
/// - [authenticated]: đã đăng nhập, được vào các route protected.
/// - [unauthenticated]: chưa đăng nhập, chỉ vào được auth routes.
enum AuthStatus { unknown, authenticated, unauthenticated }

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthStatus build() => AuthStatus.unknown;

  void setAuthenticated() => state = AuthStatus.authenticated;

  void setUnauthenticated() => state = AuthStatus.unauthenticated;
}
