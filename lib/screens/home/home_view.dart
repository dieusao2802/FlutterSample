import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/core/routes/app_routes.dart';
import 'package:todo_list/log/app_log.dart';
import 'package:todo_list/provider/home/home_provider.dart';
import 'package:todo_list/style/text_styles.dart';
import 'package:todo_list/widgets/todo_list_wdt.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks', style: AppTextStyles.h2),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            onPressed: () => _handleLogOut(context, ref),
          ),
        ],
      ),
      body: const Padding(padding: EdgeInsets.all(16.0), child: TodolistWgt()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic add todo
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Future<void> _handleLogOut(BuildContext context, WidgetRef ref) async {
    AppLog.info("Executing _handleLogOut logic");
    final success = await ref.read(homeViewModelProvider).logOut();
    if (success && context.mounted) {
      AppLog.info("Logout success, navigating to login");
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }
}