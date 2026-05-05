import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/data/services/user_db_service.dart';
import 'package:todo_list/log/app_log.dart';

class HomeViewModel {
  final UserDbService _userDbService;
  final SharedPreferences _prefs;

  HomeViewModel({required UserDbService userDbService, required SharedPreferences prefs})
      : _userDbService = userDbService,
        _prefs = prefs;

  Future<bool> logOut() async {
    try {
      // 1. Chạy các tác vụ xóa dữ liệu song song
      await Future.wait([
        _prefs.remove('user_email'),
        _userDbService.removeUser(),
      ]);

      // 2. Log thông báo thành công
      AppLog.info('User logged out successfully');
      return true;
    } catch (exception, stackTrace) {
      // 3. Log lỗi kèm theo exception và stackTrace để dễ debug
      AppLog.error('Failed to log out', exception, stackTrace);
      return false;
    }
  }
}

final homeViewModelProvider = Provider<HomeViewModel>((ref) {
  return HomeViewModel(
    userDbService: locator<UserDbService>(),
    prefs: locator<SharedPreferences>(),
  );
});