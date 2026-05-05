import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/core/enums/view_state.dart';
import 'package:todo_list/domain/usecases/auth/forgot_password_usecase.dart';

class ForgotState {
  final ViewState viewState;
  final String errorMessage;

  const ForgotState({this.viewState = ViewState.idle, this.errorMessage = ''});

  ForgotState copyWith({ViewState? viewState, String? errorMessage}) {
    return ForgotState(
      viewState: viewState ?? this.viewState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isBusy => viewState == ViewState.busy;
  bool get isError => viewState == ViewState.error;
}

class ForgotNotifier extends Notifier<ForgotState> {
  @override
  ForgotState build() => const ForgotState();

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

final forgotProvider = NotifierProvider<ForgotNotifier, ForgotState>(ForgotNotifier.new);