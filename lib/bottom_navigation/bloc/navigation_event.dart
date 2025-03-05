part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeTab extends NavigationEvent {
  final int newIndex;

  ChangeTab(this.newIndex);

  @override
  List<Object> get props => [newIndex];
}
