import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/data/local/datasource/user_local_datasource.dart';
import 'package:todo_list/data/models/user_model.dart';
import 'package:todo_list/domain/entities/user.dart';
import 'package:todo_list/domain/repositories/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final UserLocalDatasource _userDatasource;
  final SharedPreferences _prefs;

  static const _keyUserEmail = 'user_email';
  static const _keyLogin = 'user_login';

  AuthRepositoryImpl(this._userDatasource, this._prefs);

  @override
  Future<User> login(String email, String password) async {
    // Mock API — thay bằng real API khi backend sẵn sàng
    await Future.delayed(const Duration(seconds: 2));
    var existing = await _userDatasource.getByEmail(email);
    if (existing == null) {
      existing = UserModel(name: 'User Test', email: email, password: password);
      await _userDatasource.insert(existing);
    }
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setBool(_keyLogin, true);
    return existing;
  }

  @override
  Future<void> register(User user) async {
    final existing = await _userDatasource.getByEmail(user.email);
    if (existing != null) throw Exception('Email đã được sử dụng');
    await _userDatasource.insert(UserModel.fromEntity(user));
    await _prefs.setString(_keyUserEmail, user.email);
  }

  @override
  Future<User?> getSessionUser() async {
    if ((_prefs.getBool(_keyLogin) ?? false) == false) return null;
    final email = _prefs.getString(_keyUserEmail);
    if (email == null) return null;
    return _userDatasource.getByEmail(email);
  }

  @override
  Future<void> logout() async {
    await Future.wait([_userDatasource.deleteAll(), _prefs.setBool(_keyLogin, false)]);
  }

  @override
  Future<User?> getByEmail() async {
    return _userDatasource.getByEmail(_prefs.getString(_keyUserEmail) ?? "");
  }

  @override
  Future<User?> forgotPassword(String email) async {
    return _userDatasource.getByEmail(email);
  }
}
