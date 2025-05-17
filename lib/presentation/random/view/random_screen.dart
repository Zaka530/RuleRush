import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../storage/settings_storage.dart';

class RandomTestScreen extends StatelessWidget {
  const RandomTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = GoRouterState.of(context).pathParameters['language'] ?? 'ru_RU';
    final int randomTemplate = (List.generate(35, (index) => index + 1)..shuffle()).first;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SettingsStorage.setFromRandomTest(true);
      print('Открываем случайный тест $randomTemplate на языке: $language');

      context.goNamed(
        'tests',
        pathParameters: {
          'language': language,
          'templateNumber': randomTemplate.toString(),
        },
        queryParameters: {
          'source': 'random',
          'language': language,
        },
      );
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
