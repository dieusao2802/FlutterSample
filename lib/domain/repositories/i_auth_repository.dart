import 'package:todo_list/domain/entities/user.dart';

abstract class IAuthRepository {
  Future<User> login(String email, String password);
  Future<void> register(User user);
  Future<User?> getSessionUser();
  Future<void> logout();
}