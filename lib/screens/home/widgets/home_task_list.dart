import 'package:flutter/material.dart';
import 'package:todo_list/screens/home/widgets/journal_card.dart';

// Danh sách Journal hiển thị ở body của Home.
// Hiện tại dùng MOCK DATA (`mockJournals` hardcode 2 record).
// Khi wire vào DB cần: đổi sang ConsumerWidget + watch journalsProvider (hoặc tương đương).
class HomeTaskList extends StatelessWidget {
  const HomeTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    // Dùng records (Dart 3) — tuple inline, không cần khai báo class.
    // Lưu ý: tag images là String hiển thị (vd: "6 Images"), không phải số → cần đổi sau.
    const mockJournals = [
      (
        title: 'Fun day with Friends',
        desc: 'Come on, people now Smile on your bro everybody get together to try new...',
        tags: ['Fun', 'Memories'],
        images: '6 Images',
        category: 'Guys Circle',
        time: '7:24 PM',
      ),
      (
        title: 'Day spent well with Family',
        desc: 'Come on, people now Smile on your bro everybody get together to try new...',
        tags: ['Family Time'],
        images: '3 Images',
        category: 'Family',
        time: '7:24 PM',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Lề ngang 20, dọc 10.
      itemCount: mockJournals.length,
      itemBuilder: (context, index) {
        final item = mockJournals[index];
        // Spread record fields ra params của JournalCard.
        return JournalCard(
          title: item.title,
          desc: item.desc,
          tags: item.tags,
          images: item.images,
          category: item.category,
          time: item.time,
        );
      },
    );
  }
}
