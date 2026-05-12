import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/provider/home/home.dart';

import '../../../gen/strings.g.dart';

// Bottom navigation bar 4 tab + chỗ chừa cho FAB ở giữa.
// Index hiện tại được lưu ở bottomNavIndexProvider để các widget khác (vd: body của Home)
// có thể đọc chung và đổi nội dung tương ứng.
class HomeBottomNav extends ConsumerWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider); // Index tab đang active.

    return BottomAppBar(
      height: 70,
      // Chiều cao bottom bar 70px.
      color: Colors.white,
      // Nền trắng.
      // CircularNotchedRectangle + notchMargin để bo khuyết chừa chỗ cho FloatingActionButton bên trên.
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      // Khoảng cách 8px giữa FAB và mép notch.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Dàn đều các nav item.
        children: [
          _buildNavItem(ref, 0, Icons.menu_book_rounded, currentIndex), // Tab Home (cuốn sách).
          _buildNavItem(ref, 1, Icons.folder_open_rounded, currentIndex), // Tab Folders.
          // Khoảng trống 48px tương đương kích thước FAB để bottom bar không che FAB.
          const SizedBox(width: 48),
          _buildNavItem(ref, 2, Icons.list_alt_rounded, currentIndex), // Tab Tasks.
          _buildNavItem(ref, 3, Icons.person_outline_rounded, currentIndex), // Tab Profile.
        ],
      ),
    );
  }

  // 1 nav item — đổi màu icon theo currentIndex, click thì update provider.
  Widget _buildNavItem(WidgetRef ref, int index, IconData icon, int currentIndex) {
    final isSelected = currentIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        // Selected = primary. Không selected = xám nhạt 400.
        color: isSelected ? AppColors.primary : Colors.grey.shade400,
        size: 24,
      ),
      onPressed: () {
        ref.read(bottomNavIndexProvider.notifier).setIndex(index);
      },
    );
  }
}
