import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/provider/folder/folder_search.dart';
import 'package:todo_list/provider/folder/folders.dart';
import 'widgets/folder_app_bar.dart';
import 'widgets/folder_search_bar.dart';
import 'widgets/folder_list_view.dart';

class FoldersPage extends ConsumerStatefulWidget {
  const FoldersPage({super.key});

  @override
  ConsumerState createState() => _FoldersPageState();
}

class _FoldersPageState extends ConsumerState<FoldersPage> {
  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(foldersProvider);
    final keyword = ref.watch(folderSearchKeywordProvider);
    final isSearching = keyword.trim().isNotEmpty;

    return foldersAsync.when(
      loading: () => const Column(
        children: [
          FolderAppBar(folderCount: 0),
          SizedBox(height: 10),
          FolderSearchBar(),
          SizedBox(height: 10),
          Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
      error: (error, _) => Column(
        children: [
          const FolderAppBar(folderCount: 0),
          const SizedBox(height: 10),
          const FolderSearchBar(),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Text(
                'Lỗi: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
      data: (folders) => Column(
        children: [
          FolderAppBar(folderCount: folders.length),
          const SizedBox(height: 10),
          const FolderSearchBar(),
          const SizedBox(height: 10),
          Expanded(
            child: FolderListView(
              folders: folders,
              isSearching: isSearching,
            ),
          ),
        ],
      ),
    );
  }
}
