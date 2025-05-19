import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';


class TestTemplatesScreen extends StatelessWidget {
  const TestTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> templates = List.generate(35, (index) => index + 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'test_templates'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/'); // Возвращаемся на главный экран
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 колонки в ряд
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1, // Квадратные карточки
          ),
          itemCount: 35, // 35 шаблонов тестов
          itemBuilder: (context, index) {
            return _buildTestCard(context, index + 1); // Передаём номер теста
          },
        ),
      ),
    );
  }

  Widget _buildTestCard(BuildContext context, int number) {
    return InkWell(
      onTap: () {
        print('Открываем тест $number');
        context.goNamed(
          'tests',
          pathParameters: {
            'templateNumber': number.toString(),
          },
          queryParameters: {
            'source': 'templates',
          },
          extra: 'templates',

        );
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "$number",
            style: TextStyle(
              fontSize: 24, // Увеличен шрифт
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
