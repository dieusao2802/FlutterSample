import 'package:equatable/equatable.dart';
import 'package:todo_list/core/enums/view_state.dart';

abstract class BaseState extends Equatable {
  const BaseState({
    required this.viewState,
    required this.errorMessage,
  });

  final ViewState viewState;
  final String errorMessage;

  bool get isBusy => viewState == ViewState.busy;
  bool get isError => viewState == ViewState.error;
}
