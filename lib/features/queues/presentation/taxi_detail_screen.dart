import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/app/theme/app_theme.dart';
import 'package:taxirank/core/errors/rank_errors.dart';
import 'package:taxirank/core/money/format_rands.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';
import 'package:taxirank/features/queues/presentation/taxi_detail_provider.dart';

/// Addressable taxi details, fetched using the two ids in the URL.
class TaxiDetailScreen extends ConsumerWidget {
  /// Creates the screen.
  const TaxiDetailScreen({
    required this.routeId,
    required this.taxiId,
    super.key,
  });

  /// Route id from the address.
  final String routeId;

  /// Taxi id from the address.
  final String taxiId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taxi = ref.watch(taxiDetailProvider(routeId, taxiId));

    return Scaffold(
      appBar: AppBar(title: const Text('Taxi details')),
      body: taxi.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            error is RankNotFound
                ? 'Taxi not found.'
                : "We couldn't load this taxi.",
          ),
        ),
        data: (taxi) {
          final label = switch (taxi.status) {
            QueueStatus.waiting => 'Waiting',
            QueueStatus.loading => 'Loading',
            QueueStatus.full => 'Full',
            QueueStatus.unknown => 'Status not recognised',
          };

          final colours = Theme.of(context).extension<QueueStatusColors>()!;

          final colour = switch (taxi.status) {
            QueueStatus.waiting => colours.waiting,
            QueueStatus.loading => colours.loading,
            QueueStatus.full => colours.full,
            QueueStatus.unknown => colours.unknown,
          };

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taxi.registration,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(taxi.driverName),
                const SizedBox(height: 16),
                Chip(label: Text(label), backgroundColor: colour),
                Text('Position ${taxi.position} in the queue'),
                Text('${taxi.seatsTaken} passengers'),
                Text('Collected ${formatRands(taxi.collected)}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
