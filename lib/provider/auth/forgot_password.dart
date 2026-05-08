import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/core/enums/view_state.dart';
import 'package:todo_list/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:todo_list/provider/base/base_state.dart';

part 'forgot_password.g.dart';

class ForgotPasswordState extends BaseState {
  const ForgotPasswordState({super.viewState = ViewState.idle, super.errorMessage = ''});

  ForgotPasswordState copyWith({ViewState? viewState, String? errorMessage}) {
    return ForgotPasswordState(
      viewState: viewState ?? this.viewState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [viewState, errorMessage];
}

@riverpod
class ForgotPassword extends _$ForgotPassword {
  @override
  ForgotPasswordState build() => const ForgotPasswordState();

  Future<bool> sendResetNotification(String email) async {
    state = state.copyWith(viewState: ViewState.busy, errorMessage: '');
    try {
      final success = await locator<ForgotPasswordUseCase>()(email);
      if (!success) {
        state = state.copyWith(
          viewState: ViewState.error,
          errorMessage: 'Email không tồn tại trong hệ thống',
        );
        return false;
      }
      state = state.copyWith(viewState: ViewState.idle);
      return true;
    } catch (e) {
      state = state.copyWith(viewState: ViewState.error, errorMessage: e.toString());
      return false;
    }
  }
}
