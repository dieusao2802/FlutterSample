import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/data/services/user_db_service.dart';
import 'package:todo_list/model/user.dart';

class RegisterState {
  final bool isLoading;

  const RegisterState({this.isLoading = false});

  RegisterState copyWith({bool? isLoading}) {
    return RegisterState(isLoading: isLoading ?? this.isLoading);
  }
}

class RegisterNotifier extends AutoDisposeNotifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final userDbService = locator<UserDbService>();
      final prefs = locator<SharedPreferences>();

      // 1. Kiểm tra email đã tồn tại chưa
      final existingUser = await userDbService.getUser(email);
      if (existingUser != null) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      // 2. Tạo đối tượng User và lưu vào SQLite
      final newUser = User(name: name, email: email, password: password);
      await userDbService.insertUser(newUser);

      // 3. Lưu email vào SharedPreferences để đánh dấu đã đăng nhập
      await prefs.setString('user_email', email);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}

final registerProvider =
    NotifierProvider.autoDispose<RegisterNotifier, RegisterState>(RegisterNotifier.new);