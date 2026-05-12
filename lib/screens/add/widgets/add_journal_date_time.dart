import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/provider/journal/add_journal.dart';

// Hàng chọn Date + Time ở đầu màn hình Add Journal.
// - Bên trái: ngày dạng "dd MMMM" + "yyyy, EEEE" → tap mở DatePicker.
// - Bên phải: giờ dạng "h:mma" (lowercase, không có space) → tap mở TimePicker.
// State đọc/ghi qua addJournalProvider (Riverpod) để các widget khác đồng bộ.
class AddJournalDateTime extends ConsumerWidget {
  const AddJournalDateTime({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addJournalProvider); // Watch state để rebuild khi date/time đổi.
    final notifier = ref.watch(addJournalProvider.notifier); // Notifier để gọi updateDate/updateTime.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Lề ngang 20, dọc 10.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 2 nhóm cách đều, sát 2 mép.
        children: [
          // ============================================================
          // PICK DATE — date range giới hạn từ hôm nay đến năm 2101.
          // ============================================================
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: state.selectedDate, // Ngày đã chọn trước đó.
                firstDate: DateTime.now(), // Không cho chọn ngày trong quá khứ.
                lastDate: DateTime(2101), // Giới hạn xa nhất tới năm 2101.
              );
              if (picked != null) {
                notifier.updateDate(picked); // Cập nhật state, sẽ trigger rebuild.
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc.
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Title và sub-title align trái.
                  children: [
                    Text(
                      // Format: "11 May" — pattern 'dd MMMM' (zero-pad day + tên tháng đầy đủ).
                      DateFormat('dd MMMM').format(state.selectedDate),
                      style: const TextStyle(
                        fontSize: 24, // 24px lớn để nhấn ngày.
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E), // Đen dịu.
                      ),
                    ),
                    Text(
                      // Format: "2026, Monday" — năm + tên thứ đầy đủ.
                      DateFormat('yyyy, EEEE').format(state.selectedDate),
                      style: TextStyle(
                        fontSize: 14, // 14px - nhỏ hơn để là sub-title.
                        color: Colors.grey.shade500, // Xám trung bình.
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10), // Khoảng cách 10px giữa text và icon.
                Container(
                  padding: const EdgeInsets.all(8), // Padding đều 8px quanh icon.
                  decoration: BoxDecoration(
                    color: AppColors.primary, // Nền primary.
                    borderRadius: BorderRadius.circular(10), // Bo 10px.
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined, // Icon lịch (outlined).
                    color: Colors.white, // Trắng để tương phản nền primary.
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // ============================================================
          // PICK TIME — TimePicker mặc định theo locale của device.
          // ============================================================
          GestureDetector(
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: state.selectedTime,
              );
              if (picked != null) {
                notifier.updateTime(picked);
              }
            },
            child: Row(
              children: [
                Text(
                  // Format theo locale của context (12h/24h), sau đó lowercase + bỏ space.
                  // VD: "7:24 PM" → "7:24pm".
                  state.selectedTime.format(context).toLowerCase().replaceAll(' ', ''),
                  style: const TextStyle(
                    fontSize: 20, // 20px - nhỏ hơn date một chút.
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.access_time, // Icon đồng hồ.
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
