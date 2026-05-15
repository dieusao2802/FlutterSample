import 'package:flutter/material.dart';
import 'package:todo_list/screens/add/add_journal_page.dart';
import 'package:todo_list/screens/add/folder/add_folder_page.dart';
import 'package:todo_list/screens/demo/demo_resources_page.dart';
import '../../screens/auth/forgot_password_page.dart';
import '../../screens/auth/login_page.dart';
import '../../screens/auth/register_page.dart';
import '../../screens/home/home_page.dart';
import '../../screens/splash/splash_view.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String addTask = '/add-task';
  static const String addFolder = '/add-folder';
  static const String demoResources = '/demo-resources';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashPage(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    forgotPassword: (context) => const ForgotPasswordPage(),
    home: (context) => const HomePage(),
    addTask: (context) => const AddJournalPage(),
    addFolder: (context) => const AddFolderPage(),
    demoResources: (context) => const DemoResourcesPage(),
  };
}
