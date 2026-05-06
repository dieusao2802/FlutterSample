import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/core/routes/app_routes.dart';
import 'package:todo_list/log/app_log.dart';
import 'package:todo_list/provider/home/home_provider.dart';
import 'package:todo_list/style/text_styles.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('Pending Tasks', style: AppTextStyles.body)),
          Center(child: Text('Completed Tasks', style: AppTextStyles.body)),
        ],
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
