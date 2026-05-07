import 'package:flutter/material.dart';

class AddJournalFolderSelector extends StatelessWidget {
  const AddJournalFolderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade100),
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open_outlined, color: Colors.grey, size: 24),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              "Choose Folder",
              style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 24),
        ],
      ),
    );
  }
}
