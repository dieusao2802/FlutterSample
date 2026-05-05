import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/data/repositories/auth_repository.dart';
import 'package:todo_list/data/services/api_service.dart';
import 'package:todo_list/data/services/database_service.dart';
import 'package:todo_list/data/services/user_db_service.dart';
import 'package:todo_list/data/services/todo_db_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => Dio());

  // Services
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton(() => UserDbService(locator<DatabaseService>()));
  locator.registerLazySingleton(() => TodoDbService(locator<DatabaseService>()));
  locator.registerLazySingleton(() => ApiService(locator()));

  // Repositories
  locator.registerLazySingleton(() => AuthRepository());
}
