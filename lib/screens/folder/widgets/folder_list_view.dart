import 'package:flutter/material.dart';
import 'folder_item.dart';

class FolderListView extends StatelessWidget {
  const FolderListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> folders = [
      {
        "title": "Fun day with Friends",
        "journals": 3,
        "todos": 2,
        "color": Colors.orange,
      },
      {
        "title": "Day spent with Family",
        "journals": 7,
        "todos": 5,
        "color": Colors.deepPurple,
      },
      {
        "title": "Fitness Work",
        "journals": 5,
        "todos": 9,
        "color": Colors.green,
      },
      {
        "title": "Personal",
        "journals": 1,
        "todos": 5,
        "color": Colors.blue,
      },
      {
        "title": "Family",
        "journals": 11,
        "todos": 2,
        "color": Colors.teal,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        return FolderItem(
          title: folder["title"],
          journals: folder["journals"],
          todos: folder["todos"],
          leadingColor: folder["color"],
        );
      },
    );
  }
}
