import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/app/router/routes.dart';
import 'package:taxirank/core/money/format_rands.dart';
import 'package:taxirank/features/queues/presentation/routes_provider.dart';

/// The Queues tab: every route from the rank.
class RoutesScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bree Street rank')),
      body: switch (ref.watch(routesProvider)) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final route in value)
              Card(
                child: ListTile(
                  title: Text(route.name),
                  subtitle: Text(
                    route.queueLength == 0
                        ? 'No taxis'
                        : '${route.queueLength} taxis',
                  ),
                  trailing: Text(formatRands(route.fare)),
                  onTap: () => RouteQueueRoute(routeId: route.id).go(context),
                ),
              ),
          ],
        ),
        AsyncError() => const Center(child: Text("We couldn't load routes.")),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
