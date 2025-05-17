import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../models/test_model/test_model.dart';

class TestRepository {
  static Future<List<TestModel>> loadTests(String language, int templateNumber) async {
    try {
      String folderPath = 'assets/tests/parse_$language/$templateNumber/';
      List<TestModel> tests = [];

      for (int i = 1; i <= 20; i++) { // Загружаем 20 вопросов
        String textFilePath = '$folderPath$i.txt';
        String imageFilePath = 'assets/tests/parse_ru_RU/$templateNumber/$i.jpeg';

        try {
          // Загружаем текст из файла
          String textContent = await rootBundle.loadString(textFilePath);
          List<String> lines = textContent.split("\n").where((line) => line.isNotEmpty).toList();

          // Проверяем, есть ли картинка
          String? imagePath;
          try {
            await rootBundle.load(imageFilePath);
            imagePath = imageFilePath;
          } catch (e) {
            imagePath = null; // Картинки нет
          }

          tests.add(TestModel.fromFileContent(lines, 'assets/tests/parse_ru_RU/$templateNumber/', i, templateNumber, i));
        } catch (e) {
          print("Ошибка загрузки вопроса №$i: $e");
        }
      }

      return tests;
    } catch (e) {
      print("Ошибка загрузки тестов: $e");
      return [];
    }
  }

  static Future<List<TestModel>> loadAllTests(String language) async {
    List<TestModel> allTests = [];

    for (int template = 1; template <= 35; template++) {
      String folderPath = 'assets/tests/parse_$language/$template/';

      for (int i = 1; i <= 20; i++) {
        String textFilePath = '$folderPath$i.txt';
        String imageFilePath = 'assets/tests/parse_ru_RU/$template/$i.jpeg';

        try {
          String textContent = await rootBundle.loadString(textFilePath);
          List<String> lines = textContent.split("\n").where((line) => line.isNotEmpty).toList();

          String? imagePath;
          try {
            await rootBundle.load(imageFilePath);
            imagePath = imageFilePath;
          } catch (_) {
            imagePath = null;
          }

          allTests.add(TestModel.fromFileContent(lines, folderPath, i, template, i));
        } catch (e) {
          print("Ошибка загрузки вопроса $i из шаблона $template: $e");
        }
      }
    }

    return allTests;
  }
}
