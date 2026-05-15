import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:todo_list/core/constants/app_colors.dart';
import 'package:todo_list/core/di/service_locator.dart';
import 'package:todo_list/core/routes/app_routes.dart';
import 'package:todo_list/core/navigation/global_navigator.dart';
import 'package:todo_list/provider/locale/locale.dart';

import 'gen/strings.g.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await setupLocator();

  final initialLocale = await resolveInitialLocale();
  LocaleSettings.setLocale(initialLocale);

  runApp(ProviderScope(child: TranslationProvider(child: const MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch để rebuild MaterialApp khi user đổi ngôn ngữ
    // (không cần dùng value, chỉ cần subscribe thay đổi)
    ref.watch(localeControllerProvider);

    return MaterialApp(
      // --- Navigation ---
      navigatorKey: GlobalNavigator.navigatorKey,
      // Key dùng cho navigate ngoài context
      debugShowCheckedModeBanner: false,
      title: 'Journal',

      // --- i18n (slang) ---
      locale: TranslationProvider.of(context).flutterLocale,
      // Locale hiện tại từ slang
      supportedLocales: AppLocaleUtils.supportedLocales,
      // Danh sách locale slang sinh ra
      localizationsDelegates: const [
        // Delegate dịch sẵn cho widget built-in (Material/Cupertino/Widgets)
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // --- Theme ---
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),

      // --- Routes ---
      initialRoute: AppRoutes.splash,
      // Route khởi động
      routes: AppRoutes.routes, // Map route name -> builder
    );
  }
}
