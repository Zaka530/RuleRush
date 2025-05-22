import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/test_model/test_progress_model.dart';

class ProgressRepository {
  static const _key = 'user_test_progress';

  Future<void> saveProgress(TestProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> progressList =
        prefs.getStringList(_key) ?? <String>[];

    // удаляем старый прогресс по этому шаблону, если он есть
    progressList.removeWhere((item) {
      final map = jsonDecode(item);
      return map['templateId'] == progress.templateId;
    });

    progressList.add(jsonEncode(progress.toJson()));
    await prefs.setStringList(_key, progressList);
  }

  Future<List<TestProgress>> getAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> progressList =
        prefs.getStringList(_key) ?? <String>[];

    return progressList
        .map((item) => TestProgress.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<TestProgress?> getProgressForTemplate(int templateId) async {
    final all = await getAllProgress();
    return all.firstWhere(
          (progress) => progress.templateId == templateId,
      orElse: () => TestProgress(
        templateId: templateId,
        correctAnswers: 0,
        incorrectAnswers: 0,
      ),
    );
  }
}