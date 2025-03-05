class TestModel {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? imagePath; // Теперь картинка необязательна

  TestModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.imagePath,
  });

  /// Фабричный метод создания модели из файла
  factory TestModel.fromFileContent(List<String> lines, String imageFolderPath, int questionIndex) {
    if (lines.length < 3) {
      throw Exception("Некорректный формат файла: минимум 3 строки (вопрос, ответы, правильный ответ)");
    }

    String question = lines.first.trim(); // Вопрос - первая строка
    String correctAnswer = lines.last.trim(); // Последняя строка - правильный ответ
    int hasImage = int.tryParse(lines[lines.length - 2].trim()) ?? 0; // Предпоследняя строка - 0 или 1

    List<String> options = lines.sublist(1, lines.length - 2)
        .map((e) => e.trim()) // Убираем пробелы
        .where((e) => e.isNotEmpty) // Фильтруем пустые строки
        .toList();

    String? imagePath;
    if (hasImage == 1) {
      imagePath = "$imageFolderPath/$questionIndex.jpeg"; // Формируем путь к изображению
    }

    return TestModel(
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      imagePath: imagePath,
    );
  }
}
