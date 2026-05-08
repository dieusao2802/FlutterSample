import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/core/enums/view_state.dart';
import 'package:todo_list/domain/usecases/auth/login_usecase.dart';
import 'package:todo_list/provider/base/base_state.dart';

part 'login.g.dart';

class LoginState extends BaseState {
  const LoginState({super.viewState = ViewState.idle, super.errorMessage = ''});

  LoginState copyWith({ViewState? viewState, String? errorMessage}) {
    return LoginState(
      viewState: viewState ?? this.viewState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [viewState, errorMessage];
}

@riverpod
class Login extends _$Login {
  @override
  LoginState build() => const LoginState();

  Future<bool> login(String email, String password) async {
    state = state.copyWith(viewState: ViewState.busy, errorMessage: '');
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
