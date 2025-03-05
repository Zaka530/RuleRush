part of 'test_bloc.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object> get props => [];
}

class TestLoading extends TestState {}

class TestLoaded extends TestState {
  final List<TestModel> tests;

  const TestLoaded(this.tests);

  @override
  List<Object> get props => [tests];
}

class TestError extends TestState {
  final String message;

  const TestError(this.message);

  @override
  List<Object> get props => [message];
}
