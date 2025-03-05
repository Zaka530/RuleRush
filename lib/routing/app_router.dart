import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../bottom_navigation/view/bottom_nav_screen.dart';
import '../presentation/home/view/home_screen.dart';
import '../presentation/settings/view/settings_screen.dart';
import '../presentation/templates/view/test_templates_screen.dart';
import '../presentation/tests/view/test_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      // Добавляем маршрут для экрана шаблонов тестов
      GoRoute(
        path: '/test_templates',
        name: 'test_templates',
        builder: (context, state) => const TestTemplatesScreen(),
      ),
      // Универсальный маршрут для тестов
      GoRoute(
        path: '/tests/:language/:templateNumber',
        name: 'tests',
        builder: (context, state) {
          final String language = state.pathParameters['language'] ?? 'ru_RU';
          final int templateNumber = int.tryParse(state.pathParameters['templateNumber'] ?? '1') ?? 1;
          return TestScreen(language: language, templateNumber: templateNumber);
        },
      ),
    ],
  );
}
