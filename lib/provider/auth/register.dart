import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/core/enums/view_state.dart';
import 'package:todo_list/domain/entities/user.dart';
import 'package:todo_list/domain/usecases/auth/register_usecase.dart';
import 'package:todo_list/model/gender.dart';
import 'package:todo_list/provider/base/base_state.dart';

part 'register.g.dart';

typedef RegisterFormData = ({String name, String email, String password, Gender? gender});

class RegisterState extends BaseState {
  const RegisterState({
    super.viewState = ViewState.idle,
    super.errorMessage = '',
    this.registeredData,
  });

  final RegisterFormData? registeredData;

  RegisterState copyWith({
    ViewState? viewState,
    String? errorMessage,
    RegisterFormData? registeredData,
  }) {
    return RegisterState(
      viewState: viewState ?? this.viewState,
      errorMessage: errorMessage ?? this.errorMessage,
      registeredData: registeredData ?? this.registeredData,
    );
  }

  @override
  List<Object?> get props => [viewState, errorMessage, registeredData];
}

@riverpod
class Register extends _$Register {
  @override
  RegisterState build() => const RegisterState();

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required Gender? gender,
  }) async {
    state = state.copyWith(viewState: ViewState.busy, errorMessage: '');
    try {
      final user = User(name: name, email: email, password: password);
      await locator<RegisterUseCase>()(user);
      state = state.copyWith(
        viewState: ViewState.idle,
        registeredData: (name: name, email: email, password: password, gender: gender),
      );
      return true;
    } catch (e) {
      state = state.copyWith(viewState: ViewState.error, errorMessage: e.toString());
      return false;
    }
  }
}
