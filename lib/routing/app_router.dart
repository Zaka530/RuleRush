import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../bottom_navigation/view/bottom_navigation.dart';
import '../presentation/home/view/home_screen.dart';
import '../presentation/result/view/results_screen.dart';
import '../presentation/settings/view/settings_screen.dart';
import '../presentation/templates/view/test_templates_screen.dart';
import '../presentation/tests/view/test_screen.dart';
import '../presentation/marathon/view/marathon_screen.dart';
import '../presentation/random/view/random_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => MyBottomNavigation(
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => MyBottomNavigation(
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/test_templates',
        name: 'test_templates',
        builder: (context, state) => const TestTemplatesScreen(),
      ),
      GoRoute(
        path: '/tests/:templateNumber',
        name: 'tests',
        builder: (context, state) {
          final locale = context.locale;
          final language = (locale.languageCode == 'uz' && locale.countryCode == 'UZ_CYR')
              ? 'uz_UZ@cyrillic'
              : '${locale.languageCode}_${locale.countryCode}';
          final templateNumber = int.tryParse(state.pathParameters['templateNumber'] ?? '1') ?? 1;

          final fromRandomTest = state.uri.queryParameters['source'] == 'random';
          print('🧪 query source = ${state.uri.queryParameters['source']}');
          print('🧪 fromRandomTest = $fromRandomTest');

          final sourceScreen = state.extra as String?;

          return TestScreen(
            language: language,
            templateNumber: templateNumber,
            fromRandomTest: fromRandomTest,
            hideTemplateTitle: templateNumber == 0,
            sourceScreen: sourceScreen,
          );
        },
      ),
      GoRoute(
        path: '/random',
        name: 'random',
        builder: (context, state) {
          final templateNumber = (List.generate(35, (index) => index + 1)..shuffle()).first;

          print('⚡️ Переход в random с языком: ${context.locale}');

          Future.microtask(() {
            context.goNamed(
              'tests',
              pathParameters: {
                'templateNumber': templateNumber.toString(),
              },
              queryParameters: {
                'source': 'random',
              },
            );
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
      GoRoute(
        path: '/marathon',
        name: 'marathon',
        builder: (context, state) {
          final locale = context.locale;
          final language = (locale.languageCode == 'uz' && locale.countryCode == 'UZ_CYR')
              ? 'uz_UZ@cyrillic'
              : '${locale.languageCode}_${locale.countryCode}';
          return MarathonScreen(language: language);
        },
      ),
      GoRoute(
        path: '/results/:correctAnswers/:wrongAnswers/:totalQuestions',
        name: 'results',
        builder: (context, state) {
          final correct = int.tryParse(
            state.pathParameters['correctAnswers'] ?? '0'
          ) ?? 0;
          final wrong = int.tryParse(
            state.pathParameters['wrongAnswers'] ?? '0'
          ) ?? 0;
          final total = int.tryParse(
            state.pathParameters['totalQuestions'] ?? '0'
          ) ?? 0;
          final bool fromRandomTest = state.uri.queryParameters['source'] == 'random';
          return ResultsScreen(
            correctAnswers: correct,
            wrongAnswers: wrong,
            totalQuestions: total,
          );
        },
      ),
    ],
  );
}
