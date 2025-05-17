import 'package:equatable/equatable.dart';

abstract class MarathonEvent extends Equatable {
  const MarathonEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarathon extends MarathonEvent {
  final String languageCode;

  const LoadMarathon(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class NextMarathonQuestion extends MarathonEvent {}