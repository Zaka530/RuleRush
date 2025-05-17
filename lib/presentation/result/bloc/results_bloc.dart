import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rule_rush/presentation/result/bloc/results_event.dart';
import 'package:rule_rush/presentation/result/bloc/results_state.dart';

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  ResultsBloc() : super(ResultsInitial()) {
    on<LoadResults>((event, emit) {
      emit(ResultsLoaded(
        correctAnswers: event.correctAnswers,
        wrongAnswers: event.wrongAnswers,
        totalQuestions: event.totalQuestions,
      ));
    });
  }
}
