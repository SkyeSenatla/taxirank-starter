import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxirank/app/router/app_shell.dart';
import 'package:taxirank/features/departures/presentation/departures_screen.dart';
import 'package:taxirank/features/queues/presentation/route_queue_screen.dart';
import 'package:taxirank/features/queues/presentation/routes_screen.dart';
import 'package:taxirank/features/queues/presentation/taxi_details_screen.dart';

part 'routes.g.dart';

/// Stateful tabs remember a nested taxi details screen when switching tabs.
@TypedStatefulShellRoute<RankShellRoute>(
  branches: [
    TypedStatefulShellBranch<ShellBranch>(
      routes: [
        TypedGoRoute<QueuesRoute>(
          path: '/queues',
          routes: [
            TypedGoRoute<RouteQueueRoute>(
              path: ':routeId',
              routes: [
                TypedGoRoute<TaxiDetailsRoute>(path: 'taxis/:taxiId'),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ShellBranch>(
      routes: [TypedGoRoute<DeparturesRoute>(path: '/departures')],
    ),
  ],
)
class RankShellRoute extends StatefulShellRouteData {
  /// Creates the app shell.
  const RankShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => AppShell(navigationShell: navigationShell);
}

/// One tab of the shell.
class ShellBranch extends StatefulShellBranchData {
  /// Creates the branch.
  const ShellBranch();
}

/// Every route from the rank.
class QueuesRoute extends GoRouteData with $QueuesRoute {
  /// Creates the list route.
  const QueuesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RoutesScreen();
}

/// One route's queue.
class RouteQueueRoute extends GoRouteData with $RouteQueueRoute {
  /// Creates a route using its ID.
  const RouteQueueRoute({required this.routeId});

  /// Its ID, such as soweto.
  final String routeId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteQueueScreen(routeId: routeId);
}

/// One taxi, addressable without loading the queue screen first.
class TaxiDetailsRoute extends GoRouteData with $TaxiDetailsRoute {
  /// Creates a URL from the two IDs.
  const TaxiDetailsRoute({required this.routeId, required this.taxiId});

  /// Parent queue ID.
  final String routeId;

  /// Taxi ID.
  final String taxiId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TaxiDetailsScreen(routeId: routeId, taxiId: taxiId);
}

/// The Departures tab.
class DeparturesRoute extends GoRouteData with $DeparturesRoute {
  /// Creates the route.
  const DeparturesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DeparturesScreen();
}
