import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/core/enums/view_state.dart';
import 'package:todo_list/domain/entities/user.dart';
import 'package:todo_list/domain/usecases/auth/register_usecase.dart';
import 'package:todo_list/model/gender.dart';

typedef RegisterFormData = ({
  String name,
  String email,
  String password,
  Gender? gender,
});

class RegisterState {
  final ViewState viewState;
  final String errorMessage;
  final RegisterFormData? registeredData;

  const RegisterState({
    this.viewState = ViewState.idle,
    this.errorMessage = '',
    this.registeredData,
  });

  bool get isBusy => viewState == ViewState.busy;
  bool get isError => viewState == ViewState.error;
}

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required Gender? gender,
  }) async {
    state = const RegisterState(viewState: ViewState.busy);
    try {
      final user = User(name: name, email: email, password: password);
      await locator<RegisterUseCase>()(user);
      state = RegisterState(
        registeredData: (name: name, email: email, password: password, gender: gender),
      );
      return true;
    } catch (e) {
      state = RegisterState(viewState: ViewState.error, errorMessage: e.toString());
      return false;
    }
  }
}

final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(RegisterNotifier.new);
