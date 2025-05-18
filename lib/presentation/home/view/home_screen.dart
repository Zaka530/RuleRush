// Removed erroneous import of easy_localization as test_templates
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';

import '../bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeScreen()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Rule Rush",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionCard(
                      context,
                      title: "Test_templates".tr(),
                      icon: LucideIcons.squareCheck, // Заменено
                      color: Colors.blueAccent,
                      onTap: () {context.push('/test_templates');
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      context,
                      title: "Random_questions".tr(),
                      icon: LucideIcons.info, // Используем info вместо helpCircle
                      color: Colors.orangeAccent,
                      onTap: () {
                        final randomTemplate = (List.generate(35, (index) => index + 1)..shuffle()).first;
                        context.pushNamed(
                          'tests',
                          pathParameters: {
                            'templateNumber': randomTemplate.toString(),
                          },
                          queryParameters: {
                            'source': 'random',
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      context,
                      title: "Marathon".tr(),
                      icon: LucideIcons.flag, // Заменено
                      color: Colors.greenAccent,
                      onTap: () {
                        print('Открываем тест на языке: ${context.locale.toString()}');

                        context.pushNamed(
                          'marathon',
                          queryParameters: {
                            'source': 'marathon',
                          },
                        );
                      },
                    ),
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

  Widget _buildSectionCard(BuildContext context,
      {required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(LucideIcons.chevronRight, size: 24, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
