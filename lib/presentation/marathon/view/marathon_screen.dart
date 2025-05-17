import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../storage/settings_storage.dart';
import '../bloc/marathon_bloc.dart';
import '../bloc/marathon_event.dart';
import '../bloc/marathon_state.dart';
import '../../tests/view/test_screen.dart';

class MarathonScreen extends StatelessWidget {
  const MarathonScreen({super.key, required String language});

  @override
  Widget build(BuildContext context) {
    final language = GoRouterState.of(context).uri.queryParameters['language'] ?? 'ru_RU';

    return BlocProvider(
      create: (_) => MarathonBloc()..add(LoadMarathon(language)),
      child: BlocBuilder<MarathonBloc, MarathonState>(
        builder: (context, state) {
          if (state is MarathonLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is MarathonLoaded) {
            return TestScreen(
              language: language,
              templateNumber: 1,
              preloadedTests: state.tests,
              totalQuestionsOverride: state.tests.length,
              hideTemplateTitle: true,
              isMarathon: true,
            );
          } else if (state is MarathonError) {
            return Scaffold(body: Center(child: Text(state.message)));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
