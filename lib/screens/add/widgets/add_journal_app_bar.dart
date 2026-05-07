import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';

class AddJournalAppBar extends StatelessWidget {
  final String title;
  final bool isShowLeadingIcon;
  final bool isShowTrailingIcon;
  final bool isEnableLeadingIcon;
  final bool isEnableTrailingIcon;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onTrailingPressed;

  const AddJournalAppBar({
    super.key,
    required this.title,
    this.isShowLeadingIcon = true,
    this.isShowTrailingIcon = true,
    this.isEnableLeadingIcon = true,
    this.isEnableTrailingIcon = true,
    this.onLeadingPressed,
    this.onTrailingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isShowLeadingIcon)
                IconButton(
                  onPressed: isEnableLeadingIcon ? (onLeadingPressed ?? () => Navigator.pop(context)) : null,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.close, size: 20, color: isEnableLeadingIcon ? Colors.black87 : Colors.grey.shade400),
                  ),
                )
              else
                const SizedBox(width: 48),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1E1E1E)),
              ),
              if (isShowTrailingIcon)
                IconButton(
                  onPressed: isEnableTrailingIcon ? (onTrailingPressed ?? () => Navigator.pop(context)) : null,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: isEnableTrailingIcon ? AppColors.primary : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.check, size: 20, color: isEnableTrailingIcon ? AppColors.primary : Colors.grey.shade400),
                  ),
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
      ],
    );
  }
}
