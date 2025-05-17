part of 'random_bloc.dart';

abstract class RandomState {}

class RandomInitial extends RandomState {}

class RandomTemplateGenerated extends RandomState {
  final int templateNumber;

  RandomTemplateGenerated(this.templateNumber);
}