import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../storage/settings_storage.dart';

class RandomTestScreen extends StatelessWidget {
  const RandomTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final language = (locale.languageCode == 'uz' && locale.countryCode == 'UZ_CYR')
        ? 'uz_UZ@cyrillic'
        : '${locale.languageCode}_${locale.countryCode}';
    final int randomTemplate = (List.generate(35, (index) => index + 1)..shuffle()).first;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SettingsStorage.setFromRandomTest(true);
      print('Открываем случайный тест $randomTemplate на языке: $language');

      context.goNamed(
        'tests',
        pathParameters: {
          'templateNumber': randomTemplate.toString(),
        },
        queryParameters: {
          'source': 'random',
        },
      );
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
