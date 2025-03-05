part of 'test_templates_bloc.dart';

abstract class TestTemplatesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTestTemplates extends TestTemplatesEvent {}
