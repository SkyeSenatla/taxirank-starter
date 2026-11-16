import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxirank/app/router/app_shell.dart';
import 'package:taxirank/features/departures/presentation/departures_screen.dart';
import 'package:taxirank/features/queues/presentation/route_queue_screen.dart';
import 'package:taxirank/features/queues/presentation/routes_screen.dart';

part 'routes.g.dart';

/// The marshal's shell: Queues and Departures, each tab with its own stack.
@TypedStatefulShellRoute<RankShellRoute>(
  branches: [
    TypedStatefulShellBranch<ShellBranch>(
      routes: [
        TypedGoRoute<QueuesRoute>(
          path: '/queues',
          routes: [TypedGoRoute<RouteQueueRoute>(path: ':routeId')],
        ),
      ],
    ),
    TypedStatefulShellBranch<ShellBranch>(
      routes: [TypedGoRoute<DeparturesRoute>(path: '/departures')],
    ),
  ],
)
class RankShellRoute extends StatefulShellRouteData {
  /// Creates the shell.
  const new();

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
  const new();
}

/// Every route from the rank: /queues.
class QueuesRoute extends GoRouteData with $QueuesRoute {
  /// Creates the route.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RoutesScreen();
}

/// One route's queue: /queues/:routeId.
class RouteQueueRoute extends GoRouteData with $RouteQueueRoute {
  /// Creates the route for [routeId].
  const new({required this.routeId});

  /// The route's id, such as `soweto`.
  final String routeId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RouteQueueScreen(routeId: routeId);
}

/// Today's departures: /departures.
class DeparturesRoute extends GoRouteData with $DeparturesRoute {
  /// Creates the route.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DeparturesScreen();
}
