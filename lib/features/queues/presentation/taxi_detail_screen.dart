import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/app/theme/app_theme.dart';
import 'package:taxirank/core/errors/rank_errors.dart';
import 'package:taxirank/core/money/format_rands.dart';
import 'package:taxirank/features/queues/data/queue_repository_provider.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';
import 'package:taxirank/features/queues/domain/queued_taxi.dart';

part 'taxi_detail_screen.g.dart';

@riverpod
Future<QueuedTaxi> taxiDetail(Ref ref, String routeId, String taxiId) =>
    ref.watch(queueRepositoryProvider).fetchTaxi(routeId, taxiId);

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
        error: (e, _) => Center(
          child: Text(
            e is RankNotFound
                ? 'Taxi not found.'
                : "We couldn't load this taxi.",
          ),
        ),
        data: (t) {
          final label = switch (t.status) {
            QueueStatus.waiting => 'Waiting',
            QueueStatus.loading => 'Loading',
            QueueStatus.full => 'Full',
            QueueStatus.unknown => 'Status not recognised',
          };
          final c = Theme.of(context).extension<QueueStatusColors>()!;
          final colour = switch (t.status) {
            QueueStatus.waiting => c.waiting,
            QueueStatus.loading => c.loading,
            QueueStatus.full => c.full,
            QueueStatus.unknown => c.unknown,
          };
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.registration,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(t.driverName),
                const SizedBox(height: 16),
                Chip(label: Text(label), backgroundColor: colour),
                Text('Position ${t.position} in the queue'),
                Text('${t.seatsTaken} passengers'),
                Text('Collected ${formatRands(t.collected)}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
