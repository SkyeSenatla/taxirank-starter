import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The two tabs at the bottom of the screen.
class AppShell extends StatelessWidget {
  /// Creates the shell around [navigationShell].
  const new({required this.navigationShell, super.key});

  /// go_router's shell: one navigator per tab.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.format_list_numbered_outlined),
            selectedIcon: Icon(Icons.format_list_numbered),
            label: 'Queues',
          ),
          NavigationDestination(
            icon: Icon(Icons.departure_board_outlined),
            selectedIcon: Icon(Icons.departure_board),
            label: 'Departures',
          ),
        ],
      ),
    );
  }
}
