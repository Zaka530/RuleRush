import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../bloc/results_bloc.dart';
import '../bloc/results_event.dart';
import '../bloc/results_state.dart';

class ResultsScreen extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;

  const ResultsScreen({
    super.key,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final goRouterState = GoRouterState.of(context);
    final source = goRouterState.uri.queryParameters['source'] ?? 'templates';
    print('📊 ResultsScreen source: $source');
    return BlocProvider(
      create: (context) => ResultsBloc()
        ..add(LoadResults(
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
          totalQuestions: totalQuestions,
        )),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Результаты', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              debugPrint('⬅️ Назад source = $source');
              if (source == 'random') {
                context.goNamed('home');
              } else if (source == 'marathon') {
                context.go('/marathon');
              } else {
                context.go('/test_templates');
              }
            },
          ),
        ),
        body: BlocBuilder<ResultsBloc, ResultsState>(
          builder: (context, state) {
            if (state is ResultsLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Ваши результаты',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Правильных: ${state.correctAnswers}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Неправильных: ${state.wrongAnswers}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          Text(
                            'Всего вопросов: ${state.totalQuestions}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: state.correctPercentage,
                              title: '${state.correctPercentage.toStringAsFixed(1)}%',
                              color: Colors.green,
                              radius: 90,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              value: state.wrongPercentage,
                              title: '${state.wrongPercentage.toStringAsFixed(1)}%',
                              color: Colors.red,
                              radius: 90,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                          sectionsSpace: 4,
                          centerSpaceRadius: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}