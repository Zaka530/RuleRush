import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/test_model/test_model.dart';
import '../../../repositories/tests_repository/test_repository.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestLoading()) {
    on<LoadTests>(_onLoadTests);
  }

  Future<void> _onLoadTests(LoadTests event, Emitter<TestState> emit) async {
    emit(TestLoading());
    try {
      List<TestModel> tests = await TestRepository.loadTests(event.language, event.templateNumber);

      if (tests.isNotEmpty) {
        emit(TestLoaded(tests));
      } else {
        emit(TestError("Не удалось загрузить тесты. Возможно, файлы отсутствуют."));
      }
    } catch (e) {
      emit(TestError("Ошибка загрузки тестов: ${e.toString()}"));
    }
  }
}
