import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/domain/usecases/auth/login_usecase.dart';
import 'package:todo_list/core/enums/view_state.dart';

class LoginState {
  final ViewState viewState;
  final String errorMessage;

  const LoginState({this.viewState = ViewState.idle, this.errorMessage = ''});

  LoginState copyWith({ViewState? viewState, String? errorMessage}) {
    return LoginState(
      viewState: viewState ?? this.viewState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isBusy => viewState == ViewState.busy;
  bool get isError => viewState == ViewState.error;
}

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<bool> login(String email, String password) async {
    state = state.copyWith(viewState: ViewState.busy);
    try {
      await locator<LoginUseCase>()(email, password);
      state = state.copyWith(viewState: ViewState.idle);
      return true;
    } catch (e) {
      state = state.copyWith(viewState: ViewState.error, errorMessage: e.toString());
      return false;
    }
  }
}

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);