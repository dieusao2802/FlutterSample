import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/domain/usecases/auth/check_session_usecase.dart';

final splashProvider = FutureProvider<bool>((ref) async {
  final user = await locator<CheckSessionUseCase>()();
  return user != null;
});