import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/provider/home/home_provider.dart';

class HomeBottomNav extends ConsumerWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return BottomAppBar(
      height: 70,
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(ref, 0, Icons.menu_book_rounded, currentIndex),
          _buildNavItem(ref, 1, Icons.folder_open_rounded, currentIndex),
          const SizedBox(width: 48), // Space for FAB
          _buildNavItem(ref, 2, Icons.list_alt_rounded, currentIndex),
          _buildNavItem(ref, 3, Icons.person_outline_rounded, currentIndex),
        ],
      ),
    );
  }

  Widget _buildNavItem(WidgetRef ref, int index, IconData icon, int currentIndex) {
    final isSelected = currentIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? AppColors.primary : Colors.grey.shade400,
        size: 24,
      ),
      onPressed: () {
        ref.read(bottomNavIndexProvider.notifier).setIndex(index);
      },
    );
  }
}
