import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../providers/hide_bottom_navigation_provider.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MyBottomNavigation extends ConsumerStatefulWidget {
  const MyBottomNavigation({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyBottomNavigationState();
}

class _MyBottomNavigationState extends ConsumerState< MyBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    final index = ref.watch(bottomNavIndexProvider);
    final currentPath = GoRouterState.of(context).uri.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hideBottomNavigationProvider).updateVisibility(currentPath);
    });

    final hideBottomNav = ref.watch(hideBottomNavigationProvider);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widget.child,
      ),
      bottomNavigationBar: hideBottomNav.isHidden
          ? null
          : BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        currentIndex: index,
              onTap: (i) {
                ref.read(bottomNavIndexProvider.notifier).state = i;

                switch (i) {
                  case 0:
                    _navigateTo(context, '/');
                    break;
                  case 1:
                    _navigateTo(context, '/settings');
                    break;
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.home,
                    size: 32,
                  ),
                  label: 'home'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.settings,
                    size: 32,
                  ),
                  label: 'Settings'.tr(),
                ),
              ],
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
            ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    // Ensure consistency: treat '/' as home route for visibility logic
    final normalizedRoute = route == '/home' ? '/' : route;
    ref.read(hideBottomNavigationProvider).updateVisibility(normalizedRoute);

    if (GoRouterState.of(context).uri.toString() != normalizedRoute) {
      context.go(normalizedRoute);
    }
  }
}
