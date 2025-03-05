import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'test_templates_event.dart';
part 'test_templates_state.dart';

class TestTemplatesBloc extends Bloc<TestTemplatesEvent, TestTemplatesState> {
  TestTemplatesBloc() : super(TestTemplatesLoading()) {
    on<LoadTestTemplates>((event, emit) async {
      // Загружаем тесты (имитация загрузки)
      await Future.delayed(const Duration(milliseconds: 500));

      List<int> templates = List.generate(35, (index) => index + 1);

      emit(TestTemplatesLoaded(templates));
    });
  }
}
