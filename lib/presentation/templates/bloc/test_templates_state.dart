part of 'test_templates_bloc.dart';

abstract class TestTemplatesState extends Equatable {
  @override
  List<Object> get props => [];
}

class TestTemplatesLoading extends TestTemplatesState {}

class TestTemplatesLoaded extends TestTemplatesState {
  final List<int> templates;

  TestTemplatesLoaded(this.templates);

  @override
  List<Object> get props => [templates];
}
