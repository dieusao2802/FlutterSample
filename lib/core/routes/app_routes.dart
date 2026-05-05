import 'package:flutter/material.dart';
import '../../screens/auth/forgot_password_view.dart';
import '../../screens/auth/login_view.dart';
import '../../screens/auth/register_view.dart';
import '../../screens/home/home_view.dart';
import '../../screens/splash/splash_view.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashView(),
    login: (context) => const LoginView(),
    register: (context) => const RegisterView(),
    forgotPassword: (context) => const ForgotPasswordView(),
    home: (context) => const HomeView(),
  };
}
