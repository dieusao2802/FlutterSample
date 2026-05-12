import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list/core/enums/view_state.dart';
import 'package:todo_list/log/app_log.dart';
import 'package:todo_list/model/folder.dart';
import 'package:todo_list/provider/base/base_state.dart';

part 'add_journal.g.dart';

class AddJournalState extends BaseState {
  final String title;
  final String content;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final List<String> imagePaths;
  final Folder? selectedFolder;

  const AddJournalState({
    this.title = '',
    this.content = '',
    required this.selectedDate,
    required this.selectedTime,
    this.imagePaths = const [],
    this.selectedFolder,
    super.viewState = ViewState.idle,
    super.errorMessage = '',
  });

  bool get isValidData => title.trim().isNotEmpty && content.trim().isNotEmpty;

  AddJournalState copyWith({
    String? title,
    String? content,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    List<String>? imagePaths,
    Folder? selectedFolder,
    ViewState? viewState,
    String? errorMessage,
  }) {
    return AddJournalState(
      title: title ?? this.title,
      content: content ?? this.content,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      imagePaths: imagePaths ?? this.imagePaths,
      selectedFolder: selectedFolder ?? this.selectedFolder,
      viewState: viewState ?? this.viewState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    title,
    content,
    selectedDate,
    selectedTime,
    imagePaths,
    selectedFolder,
    viewState,
    errorMessage,
  ];
}

@riverpod
class AddJournal extends _$AddJournal {
  final ImagePicker _picker = ImagePicker();

  @override
  AddJournalState build() {
    final now = DateTime.now().add(const Duration(minutes: 10));
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

  void updateFolder(Folder folder) {
    state = state.copyWith(selectedFolder: folder);
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        final List<String> newPaths = [...state.imagePaths, ...images.map((e) => e.path)];
        state = state.copyWith(imagePaths: newPaths);
      }
    } catch (e) {
      AppLog.error('Failed to pick images', e);
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final List<String> newPaths = [...state.imagePaths, photo.path];
        state = state.copyWith(imagePaths: newPaths);
      }
    } catch (e) {
      AppLog.error('Failed to take photo', e);
    }
  }

  void removeImage(int index) {
    final List<String> newPaths = List.from(state.imagePaths)..removeAt(index);
    state = state.copyWith(imagePaths: newPaths);
  }

  Future<void> saveJournal() async {
    if (!state.isValidData) {
      state = state.copyWith(
        viewState: ViewState.error,
        errorMessage: 'Vui lòng nhập đầy đủ tiêu đề và nội dung',
      );
      return;
    }

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
