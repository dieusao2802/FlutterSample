import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/core/routes/app_routes.dart';
import 'package:todo_list/log/app_log.dart';
import 'package:todo_list/provider/home/home_provider.dart';
import 'package:todo_list/screens/home/widgets/home_app_bar.dart';
import 'package:todo_list/screens/home/widgets/home_bottom_nav.dart';
import 'package:todo_list/screens/home/widgets/home_date_selector.dart';
import 'package:todo_list/screens/home/widgets/home_task_list.dart';
import 'package:todo_list/screens/folder/folder_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (currentIndex != 0) {
          ref.read(bottomNavIndexProvider.notifier).setIndex(0);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFF),
        body: SafeArea(child: _buildBody(currentIndex)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppLog.error("ldaldlasdl: ", currentIndex);
            if (currentIndex == 0) {
              Navigator.pushNamed(context, AppRoutes.addTask);
            } else {
              Navigator.pushNamed(context, AppRoutes.addFolder);
            }
          },
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const HomeBottomNav(),
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeAppBar(),
            SizedBox(height: 20),
            HomeDateSelector(),
            SizedBox(height: 20),
            Expanded(child: HomeTaskList()),
          ],
        );
      case 1:
        return const FolderPage();
      case 2:
        return const Center(child: Text("List Screen"));
      case 3:
        return const Center(child: Text("Profile Screen"));
      default:
        return const SizedBox.shrink();
    }
  }
}
