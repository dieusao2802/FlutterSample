import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';

class HomeCategoryFilters extends StatefulWidget {
  const HomeCategoryFilters({super.key});

  @override
  State<HomeCategoryFilters> createState() => _HomeCategoryFiltersState();
}

class _HomeCategoryFiltersState extends State<HomeCategoryFilters> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'To do', 'In Progress', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: TextStyle(
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
