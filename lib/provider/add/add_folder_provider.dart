import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/core/enums/folder_color.dart';
import 'package:todo_list/core/enums/view_state.dart';
import 'package:todo_list/data/services/folder_db_service.dart';
import 'package:todo_list/log/app_log.dart';
import 'package:todo_list/model/folder.dart';
import 'package:todo_list/provider/base/base_state.dart';

part 'add_folder_provider.g.dart';

class AddFolderState extends BaseState {
  const AddFolderState({
    super.viewState = ViewState.idle,
    super.errorMessage = '',
    this.folderName = '',
    this.folderColor = FolderColor.orange,
  });

  final String folderName;
  final FolderColor folderColor;

  AddFolderState copyWith({
    ViewState? viewState,
    String? errorMessage,
    String? folderName,
    FolderColor? folderColor,
  }) {
    return AddFolderState(
      viewState: viewState ?? this.viewState,
      errorMessage: errorMessage ?? this.errorMessage,
      folderName: folderName ?? this.folderName,
      folderColor: folderColor ?? this.folderColor,
    );
  }

  bool get isNameValid => folderName.trim().isNotEmpty;

  @override
  List<Object?> get props => [viewState, errorMessage, folderName, folderColor];
}

@riverpod
class AddFolder extends _$AddFolder {
  @override
  AddFolderState build() => const AddFolderState();

  void updateName(String name) {
    state = state.copyWith(folderName: name, viewState: ViewState.idle, errorMessage: '');
  }

  void updateColor(FolderColor color) {
    state = state.copyWith(folderColor: color);
  }

  Future<bool> submit() async {
    if (!state.isNameValid) {
      state = state.copyWith(
        viewState: ViewState.error,
        errorMessage: 'Tên folder không được để trống',
      );
      return false;
    }

    state = state.copyWith(viewState: ViewState.busy);
    try {
      final folder = Folder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: state.folderName.trim(),
        color: state.folderColor,
      );
      await locator<FolderDbService>().insertFolder(folder);

      // Log danh sách để kiểm tra dữ liệu
      final allFolders = await locator<FolderDbService>().getFolders();
      AppLog.info('DB SUCCESS: Có ${allFolders.length} folders');
      for (var f in allFolders) {
        AppLog.debug('Folder: ${f.name} (ID: ${f.id})');
      }

      state = const AddFolderState();
      return true;
    } catch (e, stackTrace) {
      AppLog.error('Failed to submit folder', e, stackTrace);
      state = state.copyWith(viewState: ViewState.error, errorMessage: e.toString());
      return false;
    }
  }
}
