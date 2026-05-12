import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/gen/strings.g.dart';

part 'locale.g.dart';

const _prefsKey = 'app_locale';

Future<AppLocale> resolveInitialLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString(_prefsKey);
  if (saved != null) {
    return AppLocale.values.firstWhere(
      (l) => l.languageCode == saved,
      orElse: () => AppLocaleUtils.findDeviceLocale(),
    );
  }
  return AppLocaleUtils.findDeviceLocale();
}

@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  String build() {
    return LocaleSettings.currentLocale.languageCode;
  }

  Future<void> setLocale(AppLocale locale) async {
    LocaleSettings.setLocale(locale);
    state = locale.languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }
}
