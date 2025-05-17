abstract class ResultsEvent {}

class LoadResults extends ResultsEvent {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;

  LoadResults({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
  });
}
