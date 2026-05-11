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

  Future<void> updateFolder(Folder folder) async {
    await locator<FolderDbService>().updateFolder(folder);
    await refresh();
  }
}
