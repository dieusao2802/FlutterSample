import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/provider/journal/add_journal.dart';
import 'widgets/add_journal_app_bar.dart';
import 'widgets/add_journal_date_time.dart';
import 'widgets/add_journal_folder_selector.dart';
import 'widgets/add_journal_images.dart';
import 'widgets/add_journal_toolbar.dart';

@RoutePage()
class AddJournalPage extends ConsumerStatefulWidget {
  const AddJournalPage({super.key});

  @override
  ConsumerState createState() => _AddJournalPageState();
}

class _AddJournalPageState extends ConsumerState<AddJournalPage> {
  @override
  Widget build(BuildContext context) {
    // 1. Lấy Notifier để thực hiện các hàm logic (Type: AddJournal)
    final AddJournal notifier = ref.watch(addJournalProvider.notifier);

    // 2. Lắng nghe State để lấy dữ liệu hiển thị và tự động rebuild UI khi dữ liệu đổi (Type: AddJournalState)
    final AddJournalState state = ref.watch(addJournalProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AddJournalAppBar(title: "Add New Journal", isEnableTrailingIcon: state.isValidData),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AddJournalDateTime(),
                    const AddJournalFolderSelector(),
                    const AddJournalImages(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onChanged: (text) {
                          notifier.updateTitle(text);
                        },
                        decoration: InputDecoration(
                          hintText: "Title",
                          hintStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: TextField(
                        maxLines: null,
                        // Cho phép xuống dòng không giới hạn
                        keyboardType: TextInputType.multiline,
                        onChanged: (text) {
                          notifier.updateContent(text);
                        },
                        decoration: InputDecoration(
                          hintText: "Write more here...",
                          hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
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
