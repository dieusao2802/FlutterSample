import 'package:todo_list/domain/repositories/i_auth_repository.dart';
import 'package:todo_list/domain/services/i_notification_service.dart';

class ForgotPasswordUseCase {
  final IAuthRepository _authRepository;
  final INotificationService _notificationService;

  ForgotPasswordUseCase(this._authRepository, this._notificationService);

  Future<bool> call(String email) async {
    final user = await _authRepository.forgotPassword(email);
    if (user == null) return false;
    await _notificationService.sendNotification(
      title: 'Thông tin tài khoản',
      body: 'Email: ${user.email}\nPassword: ${user.password}',
    );
    return true;
  }
}