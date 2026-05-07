import 'package:flutter/material.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'widgets/add_journal_app_bar.dart';
import 'widgets/add_journal_date_time.dart';
import 'widgets/add_journal_folder_selector.dart';
import 'widgets/add_journal_toolbar.dart';

class AddJournalPage extends StatelessWidget {
  const AddJournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AddJournalAppBar(title: "Add New Journal"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AddJournalDateTime(),
                    const AddJournalFolderSelector(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Title",
                          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: TextField(
                        maxLines: null, // Cho phép xuống dòng không giới hạn
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Write more here...",
                          hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(fontSize: 16, color: Color(0xFF1E1E1E)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const AddJournalToolbar(),
          ],
        ),
      ),
    );
  }
}
