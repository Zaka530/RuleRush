part of 'test_bloc.dart';

abstract class TestEvent extends Equatable {
  const TestEvent();

  @override
  List<Object> get props => [];
}

class LoadTests extends TestEvent {
  final String language;
  final int templateNumber;

  const LoadTests(this.language, this.templateNumber);

  @override
  List<Object> get props => [language, templateNumber];
}
