import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/core/enums/folder_color.dart';
import 'package:todo_list/core/enums/view_state.dart';
import 'package:todo_list/provider/folder/add_folder.dart';

import '../widgets/add_journal_app_bar.dart';

@RoutePage()
class AddFolderPage extends ConsumerStatefulWidget {
  const AddFolderPage({super.key});

  @override
  ConsumerState<AddFolderPage> createState() => _AddFolderPageState();
}

class _AddFolderPageState extends ConsumerState<AddFolderPage> {
  final _folderNameController = TextEditingController();

  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addFolderProvider);
    final notifier = ref.read(addFolderProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AddJournalAppBar(
              title: "Add New Folder",
              isEnableTrailingIcon: state.isNameValid && state.viewState != ViewState.busy,
              onTrailingPressed: () async {
                final success = await notifier.submit();
                if (success && context.mounted) {
                  Navigator.pop(context);
                } else if (state.errorMessage.isNotEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                }
              },
            ),
            if (state.viewState == ViewState.busy) const LinearProgressIndicator(minHeight: 2),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFolderNameField(notifier),
                  const SizedBox(height: 25),
                  _buildColorSelectorLabel(),
                  const SizedBox(height: 15),
                  _buildColorList(state, notifier),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderNameField(AddFolder notifier) {
    return TextField(
      controller: _folderNameController,
      maxLines: 1,
      maxLength: 50,
      onChanged: (data) => notifier.updateName(data),
      decoration: InputDecoration(
        hintText: 'Enter Folder Name',
        prefixIcon: const Icon(Icons.add, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        counterText: "",
      ),
    );
  }

  Widget _buildColorSelectorLabel() {
    return const Text(
      "Select Folder Color",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E1E1E)),
    );
  }

  Widget _buildColorList(AddFolderState state, AddFolder notifier) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: FolderColor.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final folderColor = FolderColor.values[index];
          final isSelected = folderColor == state.folderColor;
          return _buildColorItem(folderColor, isSelected, notifier);
        },
      ),
    );
  }

  Widget _buildColorItem(FolderColor folderColor, bool isSelected, AddFolder notifier) {
    return GestureDetector(
      onTap: () => notifier.updateColor(folderColor),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: folderColor.color,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: folderColor.color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
      ),
    );
  }
}
