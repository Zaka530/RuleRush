class TestProgress {
  final int templateId; // от 1 до 35
  final int correctAnswers;
  final int incorrectAnswers;

  TestProgress({
    required this.templateId,
    required this.correctAnswers,
    required this.incorrectAnswers,
  });

  Map<String, dynamic> toJson() => {
    'templateId': templateId,
    'correctAnswers': correctAnswers,
    'incorrectAnswers': incorrectAnswers,
  };

  factory TestProgress.fromJson(Map<String, dynamic> json) {
    return TestProgress(
      templateId: json['templateId'],
      correctAnswers: json['correctAnswers'],
      incorrectAnswers: json['incorrectAnswers'],
    );
  }
}