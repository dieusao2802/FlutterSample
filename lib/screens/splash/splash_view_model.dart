import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/data/services/user_db_service.dart';

class SplashViewModel {
  final UserDbService _userDbService;
  final SharedPreferences _prefs;

  SplashViewModel({required UserDbService userDbService, required SharedPreferences prefs})
      : _userDbService = userDbService,
        _prefs = prefs;

  Future<bool> checkUserLoggedIn() async {
    // 1. Kiểm tra email trong SharedPreferences
    final email = _prefs.getString('user_email');
    if (email == null) return false;

    // 2. Kiểm tra user trong SQLite
    final user = await _userDbService.getUser(email);
    return user != null;
  }
}

final splashViewModelProvider = Provider<SplashViewModel>((ref) {
  return SplashViewModel(
    userDbService: locator<UserDbService>(),
    prefs: locator<SharedPreferences>(),
  );
});