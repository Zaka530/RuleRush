abstract class ResultsState {}

class ResultsInitial extends ResultsState {}

class ResultsLoaded extends ResultsState {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;
  final double correctPercentage;
  final double wrongPercentage;

  ResultsLoaded({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
  })  : correctPercentage = (correctAnswers / totalQuestions) * 100,
        wrongPercentage = (wrongAnswers / totalQuestions) * 100;
}
