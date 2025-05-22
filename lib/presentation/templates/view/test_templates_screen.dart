import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../repositories/tests_repository/test_progress_repository.dart';
import '../../../models/test_model/test_progress_model.dart';

class TestTemplatesScreen extends StatefulWidget {
  const TestTemplatesScreen({super.key});

  @override
  State<TestTemplatesScreen> createState() => _TestTemplatesScreenState();
}

class _TestTemplatesScreenState extends State<TestTemplatesScreen> {
  List<TestProgress> _progressList = [];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await ProgressRepository().getAllProgress();
    setState(() {
      _progressList = progress;
    });
  }

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
    final progress = _progressList.firstWhere(
      (p) => p.templateId == number,
      orElse: () => TestProgress(templateId: number, correctAnswers: 0, incorrectAnswers: 0),
    );

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$number",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: LinearProgressIndicator(
                  value: (progress.correctAnswers + progress.incorrectAnswers) == 0
                      ? 0
                      : progress.correctAnswers /
                          (progress.correctAnswers + progress.incorrectAnswers),
                  backgroundColor: Colors.red.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: Colors.green, size: 14),
                  const SizedBox(width: 4),
                  Text('${progress.correctAnswers}', style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 12),
                  Icon(Icons.close, color: Colors.red, size: 14),
                  const SizedBox(width: 4),
                  Text('${progress.incorrectAnswers}', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
