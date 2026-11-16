import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Queues and Departures keep independent navigation stacks.
class AppShell extends StatelessWidget {
  /// Creates the shell around the stateful navigator.
  const AppShell({required this.navigationShell, super.key});

  /// The shell supplied by go_router.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    void select(int index) => navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    const bottomDestinations = <NavigationDestination>[
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
    ];
    return Scaffold(
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: select,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.format_list_numbered_outlined),
                      selectedIcon: Icon(Icons.format_list_numbered),
                      label: Text('Queues'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.departure_board_outlined),
                      selectedIcon: Icon(Icons.departure_board),
                      label: Text('Departures'),
                    ),
                  ],
                ),
                Expanded(child: navigationShell),
              ],
            )
          : navigationShell,
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: select,
              destinations: bottomDestinations,
            ),
    );
  }
}
