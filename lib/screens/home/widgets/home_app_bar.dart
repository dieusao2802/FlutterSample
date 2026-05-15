import 'package:flutter/material.dart';
import 'package:todo_list/core/routes/app_routes.dart';

// App bar cho màn hình Home — layout: [menu] [tiêu đề] [search].
// Hiện tại các icon menu/search chỉ là decorative (chưa wire callback).
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Lề ngang 15, dọc 10.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 3 phần tử cách đều, sát 2 mép.
        children: [
          // Tạm dùng icon menu làm entry mở màn hình Demo Resources.
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.demoResources),
            child: Container(
              padding: const EdgeInsets.all(8), // Padding đều 8px quanh icon.
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200), // Viền xám rất nhạt.
                borderRadius: BorderRadius.circular(10), // Bo 10px.
              ),
              child: const Icon(
                Icons.menu_rounded, // Icon ☰ (rounded).
                size: 24,
                color: Colors.black87, // Đen 87% opacity.
              ),
            ),
          ),
          // Tiêu đề app hardcode ở giữa.
          const Text(
            "Pronto Journals",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1E1E),
            ),
          ),
          // Icon search bên phải — chưa wire onPressed (sẽ cần mở màn search sau).
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.search_rounded, // Icon kính lúp (rounded).
              size: 24,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
