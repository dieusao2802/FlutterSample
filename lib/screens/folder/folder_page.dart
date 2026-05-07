import 'package:flutter/material.dart';
import 'widgets/folder_app_bar.dart';
import 'widgets/folder_search_bar.dart';
import 'widgets/folder_list_view.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FolderAppBar(folderCount: 5),
        SizedBox(height: 10),
        FolderSearchBar(),
        SizedBox(height: 10),
        Expanded(
          child: FolderListView(),
        ),
      ],
    );
  }
}
