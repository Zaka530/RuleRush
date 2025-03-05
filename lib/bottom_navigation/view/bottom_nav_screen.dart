import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../presentation/home/view/home_screen.dart';
import '../bloc/navigation_bloc.dart';

class BottomNavScreen extends StatelessWidget {
  final Widget child;
  const BottomNavScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: child, // Здесь GoRouter вставляет нужный экран
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                if (index == 1) {
                  context.go('/settings'); // Теперь не заменяет весь экран!
                } else {
                  context.read<NavigationBloc>().add(ChangeTab(index));
                  context.go('/'); // Переключение на HomeScreen
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.house),
                  label: 'Главная',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.settings),
                  label: 'Настройки',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
