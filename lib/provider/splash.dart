import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/domain/usecases/auth/check_session_usecase.dart';

part 'splash.g.dart';

@riverpod
Future<bool> splash(Ref ref) async {
  final user = await locator<CheckSessionUseCase>()();
  return user != null;
}
