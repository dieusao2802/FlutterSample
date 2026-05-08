import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_search.g.dart';

@riverpod
class FolderSearchKeyword extends _$FolderSearchKeyword {
  @override
  String build() => '';

  void setKeyword(String value) => state = value;

  void clear() => state = '';
}
