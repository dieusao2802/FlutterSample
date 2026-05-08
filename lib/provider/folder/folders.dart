import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/data/services/folder_db_service.dart';
import 'package:todo_list/model/folder.dart';
import 'package:todo_list/provider/folder/folder_search.dart';

part 'folders.g.dart';

@riverpod
class Folders extends _$Folders {
  @override
  Future<List<Folder>> build() async {
    final keyword = ref.watch(folderSearchKeywordProvider);
    return locator<FolderDbService>().searchFolders(keyword);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteFolder(String id) async {
    await locator<FolderDbService>().deleteFolder(id);
    await refresh();
  }

  Future<void> updateFolderName(String id, String newName) async {
    final currentFolders = state.value ?? [];
    try {
      final folder = currentFolders.firstWhere((f) => f.id == id);
      await locator<FolderDbService>().updateFolder(folder.copyWith(name: newName));
      await refresh();
    } catch (e) {
      // Folder not found or update failed
    }
  }
}
