import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list/core/enums/view_state.dart';
import 'package:todo_list/log/app_log.dart';
import 'package:todo_list/provider/base/base_state.dart';

part 'add_journal_provider.g.dart';

class AddJournalState extends BaseState {
  final String title;
  final String content;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const AddJournalState({
    this.title = '',
    this.content = '',
    required this.selectedDate,
    required this.selectedTime,
    super.viewState = ViewState.idle,
    super.errorMessage = '',
  });

  AddJournalState copyWith({
    String? title,
    String? content,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    ViewState? viewState,
    String? errorMessage,
  }) {
    return AddJournalState(
      title: title ?? this.title,
      content: content ?? this.content,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      viewState: viewState ?? this.viewState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [title, content, selectedDate, selectedTime, viewState, errorMessage];
}

@riverpod
class AddJournal extends _$AddJournal {
  @override
  AddJournalState build() {
    final now = DateTime.now();
    return AddJournalState(selectedDate: now, selectedTime: TimeOfDay.fromDateTime(now));
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateTime(TimeOfDay time) {
    state = state.copyWith(selectedTime: time);
  }

  Future<void> saveJournal() async {
    state = state.copyWith(viewState: ViewState.busy);
    try {
      // Giả lập lưu dữ liệu
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(viewState: ViewState.idle);
    } catch (e, stackTrace) {
      AppLog.error('Failed to save journal', e, stackTrace);
      state = state.copyWith(viewState: ViewState.error, errorMessage: e.toString());
    }
  }
}
