import 'package:todo_list/domain/entities/user.dart';
import 'package:todo_list/domain/repositories/i_auth_repository.dart';

class RegisterUseCase {
  final IAuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<void> call(User user) {
    return _repository.register(user);
  }
}
