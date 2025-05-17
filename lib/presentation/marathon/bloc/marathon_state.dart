

import 'package:equatable/equatable.dart';
import '../../../models/test_model/test_model.dart';

abstract class MarathonState extends Equatable {
  const MarathonState();

  @override
  List<Object?> get props => [];
}

class MarathonInitial extends MarathonState {}

class MarathonLoading extends MarathonState {}

class MarathonLoaded extends MarathonState {
  final List<TestModel> tests;
  final int currentIndex;

  const MarathonLoaded({required this.tests, required this.currentIndex});

  TestModel get currentTest => tests[currentIndex];

  bool get isLast => currentIndex >= tests.length - 1;

  @override
  List<Object?> get props => [tests, currentIndex];
}

class MarathonFinished extends MarathonState {}

class MarathonError extends MarathonState {
  final String message;

  const MarathonError(this.message);

  @override
  List<Object?> get props => [message];
}