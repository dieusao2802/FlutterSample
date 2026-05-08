import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/core/enums/view_state.dart';
import 'package:todo_list/domain/usecases/auth/logout_usecase.dart';
import 'package:todo_list/log/app_log.dart';
import 'package:todo_list/provider/base/base_state.dart';

part 'home.g.dart';

class HomeState extends BaseState {
  const HomeState({super.viewState = ViewState.idle, super.errorMessage = ''});

  HomeState copyWith({ViewState? viewState, String? errorMessage}) {
    return HomeState(
      viewState: viewState ?? this.viewState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [viewState, errorMessage];
}

@riverpod
class Home extends _$Home {
  @override
  HomeState build() => const HomeState();

  Future<bool> logOut() async {
    state = state.copyWith(viewState: ViewState.busy);
    try {
      await locator<LogoutUseCase>()();
      AppLog.info('User logged out successfully');
      state = state.copyWith(viewState: ViewState.idle);
      return true;
    } catch (exception, stackTrace) {
      AppLog.error('Failed to log out', exception, stackTrace);
      state = state.copyWith(viewState: ViewState.error, errorMessage: exception.toString());
      return false;
    }
  }
}

@riverpod
class BottomNavIndex extends _$BottomNavIndex {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}
