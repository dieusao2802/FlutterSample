import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Cổng truy cập navigation ngoài [BuildContext].
/// - [navigatorKey] gắn vào root Navigator của AutoRouter.
/// - [router] được gán 1 lần khi AppRouter được khởi tạo, dùng cho các service
///   không có context.
class GlobalNavigator {
  GlobalNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static StackRouter? router;
}
