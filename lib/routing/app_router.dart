import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/home/view/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Здесь добавим другие маршруты позже
    ],
  );
}
