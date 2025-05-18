import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Выберите язык',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (context) {
                      final locale = context.locale;
                      final currentLanguage = '${locale.languageCode}_${locale.countryCode}';
                      return Column(
                        children: [
                          _buildLanguageTile(context, 'Русский', 'ru_RU', currentLanguage),
                          _buildLanguageTile(context, 'Oʻzbekcha (Lotin)', 'uz_UZ', currentLanguage),
                          _buildLanguageTile(context, 'Ўзбекча (Кирил)', 'uz_UZ@cyrillic', currentLanguage),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, mode, _) {
                final isDark = mode == ThemeMode.dark;
                return SwitchListTile(
                  title: const Text("Тёмная тема"),
                  value: isDark,
                  onChanged: (value) {
                    themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                    print('Тема изменена: ${value ? 'тёмная' : 'светлая'}');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLanguageTile(BuildContext context, String label, String value, String selectedValue) {
  final isSelected = value == selectedValue;
  return InkWell(
    onTap: () async {
      final locale = switch (value) {
        'ru_RU' => const Locale('ru', 'RU'),
        'uz_UZ' => const Locale('uz', 'UZ'),
        'uz_UZ@cyrillic' => const Locale('uz', 'UZ_CYR'),
        _ => const Locale('ru', 'RU'),
      };
      context.setLocale(locale);
      print('Выбран язык: $value');
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
          width: isSelected ? 1.8 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.language, color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
        ],
      ),
    ),
  );
}
