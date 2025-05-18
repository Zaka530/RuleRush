import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rule_rush/routing/app_router.dart';
import 'package:rule_rush/storage/settings_storage.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
final languageNotifier = ValueNotifier<String>('ru_RU');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  themeNotifier.value = await SettingsStorage.loadThemeMode();
  print('Загруженная тема: ${themeNotifier.value}');
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('uz', 'UZ'),
        Locale.fromSubtags(languageCode: 'uz', countryCode: 'UZ_CYR'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('ru', 'RU'),
      saveLocale: true,
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp.router(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          debugShowCheckedModeBanner: false,
          title: 'Rule Rush',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ).copyWith(
              background: const Color(0xFF121212),
              surface: const Color(0xFF1E1E1E),
              surfaceVariant: const Color(0xFF2C2C2C),
              onSurface: Colors.white,
              primary: Colors.deepPurpleAccent,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            dividerColor: Colors.white24,
            dialogBackgroundColor: const Color(0xFF1E1E1E),
            iconTheme: const IconThemeData(color: Colors.white70),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
              bodySmall: TextStyle(color: Colors.white60),
              titleLarge: TextStyle(color: Colors.white),
              labelLarge: TextStyle(color: Colors.white),
            ),
            useMaterial3: true,
          ),
          themeMode: currentMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}

Widget answerOptionWidget(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Text(
      'Вариант ответа',
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );
}
