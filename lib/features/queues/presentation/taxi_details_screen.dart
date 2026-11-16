import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/app/router/routes.dart';
import 'package:taxirank/app/theme/app_theme.dart';
import 'package:taxirank/core/errors/rank_errors.dart';
import 'package:taxirank/core/money/format_rands.dart';
import 'package:taxirank/features/queues/domain/taxi_details.dart';
import 'package:taxirank/features/queues/presentation/taxi_details_provider.dart';

/// Each taxi has its own address and independently fetched details.
class TaxiDetailsScreen extends ConsumerWidget {
  /// Creates a detail page using only two route parameters.
  const TaxiDetailsScreen({
    required this.routeId,
    required this.taxiId,
    super.key,
  });

  /// Route ID.
  final String routeId;

  /// Taxi ID.
  final String taxiId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(taxiDetailsProvider(routeId, taxiId));
    return Scaffold(
      appBar: AppBar(title: const Text('Taxi details')),
      body: switch (result) {
        AsyncData(:final value) => _Details(details: value),
        AsyncError(error: RankNotFound()) => const Center(
          child: Text('Taxi not found.'),
        ),
        AsyncError(:final error) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("We couldn't load this taxi."),
              if (error is RankError) Text('Reference: ${error.reference}'),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () =>
                    ref.invalidate(taxiDetailsProvider(routeId, taxiId)),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.details});
  final TaxiDetails details;

  @override
  Widget build(BuildContext context) {
    final taxi = details.taxi;
    final colors = Theme.of(context).extension<RankStatusColors>()!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(taxi.registration, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(details.routeName),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.circle, size: 12, color: colors.forStatus(taxi.status)),
            const SizedBox(width: 8),
            Text(taxi.status.label),
          ],
        ),
        const SizedBox(height: 12),
        Text('Driver: ${taxi.driverName}'),
        Text('Position ${taxi.position} in the queue'),
        Text('${taxi.seatsTaken} of ${details.capacity} seats'),
        Text('Collected: ${formatRands(taxi.collected)}'),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => RouteQueueRoute(routeId: details.routeId).go(context),
          icon: const Icon(Icons.list),
          label: const Text('Back to queue'),
        ),
      ],
    );
  }
}
