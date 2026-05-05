import 'package:shared_preferences/shared_preferences.dart';

import '../data/services/user_db_service.dart';

enum ViewState { idle, busy, error }

class BaseViewModel {
  final UserDbService _userDbService;
  final SharedPreferences _prefs;

  UserDbService get userDbService => _userDbService;
  SharedPreferences get prefs => _prefs;

  BaseViewModel({required UserDbService userDbService, required SharedPreferences prefs})
      : _userDbService = userDbService,
        _prefs = prefs;
}