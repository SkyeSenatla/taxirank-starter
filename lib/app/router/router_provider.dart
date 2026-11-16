import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/app/router/routes.dart';

part 'router_provider.g.dart';

/// The app's one router.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(
    initialLocation: const QueuesRoute().location,
    routes: $appRoutes,
    redirect: (context, state) =>
        state.uri.path == '/' ? const QueuesRoute().location : null,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: const Center(child: Text('Page not found.')),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
}
