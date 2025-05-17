import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'random_event.dart';
part 'random_state.dart';

class RandomBloc extends Bloc<RandomEvent, RandomState> {
  RandomBloc() : super(RandomInitial()) {
    on<GenerateRandomTemplateEvent>((event, emit) {
      final randomIndex = Random().nextInt(35) + 1; // от 1 до 35
      emit(RandomTemplateGenerated(randomIndex));
    });
  }
}