import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/domain/usecases/auth/logout_usecase.dart';
import 'package:todo_list/log/app_log.dart';

class HomeViewModel {
  final LogoutUseCase _logout;

  HomeViewModel(this._logout);

  Future<bool> logOut() async {
    try {
      await _logout();
      AppLog.info('User logged out successfully');
      return true;
    } catch (exception, stackTrace) {
      AppLog.error('Failed to log out', exception, stackTrace);
      return false;
    }
  }
}


final homeViewModelProvider = Provider<HomeViewModel>((ref) {
  return HomeViewModel(locator<LogoutUseCase>());
});