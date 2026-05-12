import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';

// Hàng chip filter category theo chiều ngang ở Home (All / To do / In Progress / Completed).
// State được giữ local trong StatefulWidget — chưa nâng lên provider vì chưa wire vào filter danh sách.
class HomeCategoryFilters extends StatefulWidget {
  const HomeCategoryFilters({super.key});

  @override
  State<HomeCategoryFilters> createState() => _HomeCategoryFiltersState();
}

class _HomeCategoryFiltersState extends State<HomeCategoryFilters> {
  // Category đang được chọn — string thuần. Default = 'All'.
  String _selectedCategory = 'All';

  // Danh sách category hardcode. Nếu sau này thay đổi/dùng i18n thì cần convert sang enum/const.
  final List<String> _categories = ['All', 'To do', 'In Progress', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, // Chiều cao chip 40px.
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Cuộn ngang.
        padding: const EdgeInsets.symmetric(horizontal: 15), // Lề ngang 15.
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category), // Đổi category khi tap.
            child: Container(
              margin: const EdgeInsets.only(right: 12), // Khoảng 12px giữa các chip.
              padding: const EdgeInsets.symmetric(horizontal: 24), // Padding ngang trong chip 24px.
              decoration: BoxDecoration(
                // Selected = nền primary. Còn lại = nền xám rất nhạt (#F1F1F1).
                color: isSelected ? AppColors.primary : const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(20), // Bo 20px cho hình pill.
              ),
              alignment: Alignment.center, // Text căn giữa trong chip.
              child: Text(
                category,
                style: TextStyle(
                  // Selected = trắng. Còn lại = xám đậm 600.
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
