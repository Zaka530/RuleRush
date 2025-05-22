import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../models/test_model/results_metadata.dart';
import '../../../models/test_model/test_progress_model.dart';
import '../../../repositories/tests_repository/test_progress_repository.dart';
import '../bloc/results_bloc.dart';
import '../bloc/results_event.dart';
import '../bloc/results_state.dart';

class ResultsScreen extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;
  final ResultsMetadata? resultsMetadata;



  const ResultsScreen({
    super.key,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
    this.resultsMetadata,

  });

  @override
  Widget build(BuildContext context) {
    final goRouterState = GoRouterState.of(context);
    final source = goRouterState.uri.queryParameters['source'] ?? 'templates';
    print(' ResultsScreen source: $source');
    return BlocProvider(
      create: (context) => ResultsBloc()
        ..add(LoadResults(
          correctAnswers: correctAnswers,
          wrongAnswers: wrongAnswers,
          totalQuestions: totalQuestions,
        )),
      child: Scaffold(
        appBar: AppBar(
          title: Text('results'.tr(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              debugPrint('Назад source = $source');
              switch (source) {
                case 'random':
                case 'marathon':
                  context.goNamed('home');
                  break;
                case 'templates':
                  context.go('/test_templates');
                  break;
                default:
                  context.pop();
              }
            },
          ),
        ),
        body: BlocBuilder<ResultsBloc, ResultsState>(
          builder: (context, state) {
            if (state is ResultsLoaded) {
              int? templateId = resultsMetadata?.templateId;

              if (templateId == null) {
                final templateIdStr = goRouterState.uri.queryParameters['templateId'];
                templateId = int.tryParse(templateIdStr ?? '');
              }

              if (templateId != null) {
                final progress = TestProgress(
                  templateId: templateId,
                  correctAnswers: state.correctAnswers,
                  incorrectAnswers: state.wrongAnswers,
                );
                ProgressRepository().saveProgress(progress);
                debugPrint('[📊 Progress Saved] templateId=$templateId, correct=${state.correctAnswers}, wrong=${state.wrongAnswers}');
              } else {
                debugPrint('[⚠️ Progress Skipped] No templateId in metadata or queryParameters.');
              }
              final bool passed = state.correctAnswers / state.totalQuestions >= 0.9;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          passed ? Icons.check_circle_outline : Icons.cancel_outlined,
                          color: passed ? Colors.green : Colors.red,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          passed ? 'exam_passed'.tr() : 'exam_failed'.tr(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: passed ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                            '${'correct'.tr()}: ${state.correctAnswers}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${'incorrect'.tr()}: ${state.wrongAnswers}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          Text(
                            '${'total_questions'.tr()}: ${state.totalQuestions}',
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