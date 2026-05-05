import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/data/local/database/app_database.dart';
import 'package:todo_list/data/local/datasource/user_local_datasource.dart';
import 'package:todo_list/data/repositories/auth_repository_impl.dart';
import 'package:todo_list/data/services/api_service.dart';
import 'package:todo_list/data/services/database_service.dart';
import 'package:todo_list/data/services/local_notification_service.dart';
import 'package:todo_list/data/services/todo_db_service.dart';
import 'package:todo_list/domain/repositories/i_auth_repository.dart';
import 'package:todo_list/domain/services/i_notification_service.dart';
import 'package:todo_list/domain/usecases/auth/check_session_usecase.dart';
import 'package:todo_list/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:todo_list/domain/usecases/auth/login_usecase.dart';
import 'package:todo_list/domain/usecases/auth/logout_usecase.dart';
import 'package:todo_list/domain/usecases/auth/register_usecase.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => Dio());

  // Database
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton(() => TodoDbService(locator<DatabaseService>()));
  locator.registerLazySingleton(() => ApiService(locator()));

  // Datasources
  locator.registerLazySingleton(() => UserLocalDatasource(locator<AppDatabase>()));

  // Repositories
  locator.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(locator<UserLocalDatasource>(), locator<SharedPreferences>()),
  );

  // Services
  final notificationService = LocalNotificationService();
  await notificationService.initialize();
  locator.registerLazySingleton<INotificationService>(() => notificationService);

  // Use Cases
  locator.registerLazySingleton(() => LoginUseCase(locator<IAuthRepository>()));
  locator.registerLazySingleton(() => RegisterUseCase(locator<IAuthRepository>()));
  locator.registerLazySingleton(() => CheckSessionUseCase(locator<IAuthRepository>()));
  locator.registerLazySingleton(() => LogoutUseCase(locator<IAuthRepository>()));
  locator.registerLazySingleton(
    () => ForgotPasswordUseCase(locator<IAuthRepository>(), locator<INotificationService>()),
  );
}