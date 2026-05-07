import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';

class AddJournalDateTime extends StatelessWidget {
  const AddJournalDateTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "05 April",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                  ),
                  Text("2021, Wednesday", style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 20),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "03:40pm",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.access_time, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
