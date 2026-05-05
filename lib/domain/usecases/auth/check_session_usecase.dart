import 'package:todo_list/domain/entities/user.dart';
import 'package:todo_list/domain/repositories/i_auth_repository.dart';

class CheckSessionUseCase {
  final IAuthRepository _repository;

  CheckSessionUseCase(this._repository);

  Future<User?> call() {
    return _repository.getSessionUser();
  }
}