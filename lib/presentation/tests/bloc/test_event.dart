part of 'test_bloc.dart';

abstract class TestEvent extends Equatable {
  const TestEvent();

  @override
  List<Object> get props => [];
}

class LoadTests extends TestEvent {
  final String language;
  final int templateNumber;
  final bool fromRandomTest;

  const LoadTests(this.language, this.templateNumber, {this.fromRandomTest = false});

  @override
  List<Object> get props => [language, templateNumber, fromRandomTest];
}
