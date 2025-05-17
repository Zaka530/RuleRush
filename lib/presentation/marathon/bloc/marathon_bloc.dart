import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/test_model/test_model.dart';
import '../../../repositories/tests_repository/test_repository.dart';
import 'marathon_event.dart';
import 'marathon_state.dart';


class MarathonBloc extends Bloc<MarathonEvent, MarathonState> {
  MarathonBloc() : super(MarathonInitial()) {
    on<LoadMarathon>(_onLoadMarathon);
    on<NextMarathonQuestion>(_onNextMarathonQuestion);
  }

  Future<void> _onLoadMarathon(
      LoadMarathon event, Emitter<MarathonState> emit) async {
    emit(MarathonLoading());

    try {
      final tests = await TestRepository.loadAllTests(event.languageCode);
      if (tests.isNotEmpty) {
        emit(MarathonLoaded(tests: tests, currentIndex: 0));
      } else {
        emit(MarathonError('Не удалось загрузить марафон-тесты.'));
      }
    } catch (e) {
      emit(MarathonError('Ошибка при загрузке: $e'));
    }
  }

  void _onNextMarathonQuestion(
      NextMarathonQuestion event, Emitter<MarathonState> emit) {
    if (state is MarathonLoaded) {
      final currentState = state as MarathonLoaded;
      final nextIndex = currentState.currentIndex + 1;

      if (nextIndex < currentState.tests.length) {
        emit(MarathonLoaded(tests: currentState.tests, currentIndex: nextIndex));
      } else {
        emit(MarathonFinished());
      }
    }
  }
}