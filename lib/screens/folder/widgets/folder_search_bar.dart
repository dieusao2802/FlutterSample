import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/provider/folder/folder_search.dart';

class FolderSearchBar extends ConsumerStatefulWidget {
  const FolderSearchBar({super.key});

  @override
  ConsumerState<FolderSearchBar> createState() => _FolderSearchBarState();
}

class _FolderSearchBarState extends ConsumerState<FolderSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(folderSearchKeywordProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    ref.read(folderSearchKeywordProvider.notifier).setKeyword(value);
  }

  void _onClear() {
    _controller.clear();
    ref.read(folderSearchKeywordProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final keyword = ref.watch(folderSearchKeywordProvider);
    final hasText = keyword.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: "Search Folder Name",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 22),
            suffixIcon: hasText
                ? IconButton(
                    icon: Icon(Icons.close_rounded, color: Colors.grey.shade500, size: 20),
                    onPressed: _onClear,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}
