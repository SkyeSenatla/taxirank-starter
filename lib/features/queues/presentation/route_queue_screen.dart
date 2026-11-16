import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/app/router/routes.dart';
import 'package:taxirank/app/theme/app_theme.dart';
import 'package:taxirank/core/errors/rank_errors.dart';
import 'package:taxirank/core/money/format_rands.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';
import 'package:taxirank/features/queues/presentation/selected_queue_controller.dart';

/// One route's queue, for the marshal.
class RouteQueueScreen extends ConsumerWidget {
  /// Creates the screen for [routeId].
  const RouteQueueScreen({required this.routeId, super.key});

  /// The route in the address.
  final String routeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(selectedQueueProvider(routeId));
    return Scaffold(
      appBar: AppBar(title: Text(queue.asData?.value?.routeName ?? 'Queue')),
      body: queue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _QueueError(
          message: error is RankNotFound
              ? 'Route not found.'
              : "We couldn't load this queue.",
          reference: error is RankError ? error.reference : null,
          onRetry: () => ref.invalidate(selectedQueueProvider(routeId)),
        ),
        data: (value) => value.taxis.isEmpty
            ? const Center(child: Text('No taxis waiting on this route.'))
            : _QueueList(queue: value),
      ),
    );
  }
}

class _QueueError extends StatelessWidget {
  const _QueueError({
    required this.message,
    required this.onRetry,
    this.reference,
  });
  final String message;
  final String? reference;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message),
        if (reference != null) Text('Reference: $reference'),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    ),
  );
}

class _QueueList extends ConsumerWidget {
  const _QueueList({required this.queue});
  final RouteQueue queue;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      for (final taxi in queue.taxis)
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _colour(context, taxi.status),
              child: Text('${taxi.position}'),
            ),
            title: Text(taxi.registration),
            subtitle: Text(
              '${taxi.driverName} · ${taxi.seatsTaken} of ${queue.capacity} seats · ${formatRands(taxi.collected)} · ${_label(taxi.status)}',
            ),
            isThreeLine: true,
            onTap: () => TaxiDetailRoute(
              routeId: queue.routeId,
              taxiId: taxi.id,
            ).push(context),
            trailing: _action(
              ref,
              queue.routeId,
              taxi.status,
              taxi.seatsTaken < queue.capacity,
              taxi.id,
            ),
          ),
        ),
    ],
  );
  Color _colour(BuildContext context, QueueStatus status) {
    final c = Theme.of(context).extension<QueueStatusColors>()!;
    return switch (status) {
      QueueStatus.waiting => c.waiting,
      QueueStatus.loading => c.loading,
      QueueStatus.full => c.full,
      QueueStatus.unknown => c.unknown,
    };
  }

  String _label(QueueStatus status) => switch (status) {
    QueueStatus.waiting => 'Waiting',
    QueueStatus.loading => 'Loading',
    QueueStatus.full => 'Full',
    QueueStatus.unknown => 'Status not recognised',
  };
  Widget? _action(
    WidgetRef ref,
    String routeId,
    QueueStatus status,
    bool seatFree,
    String taxiId,
  ) => switch ((status, seatFree)) {
    (QueueStatus.loading, true) => FilledButton(
      onPressed: () =>
          ref.read(selectedQueueProvider(routeId).notifier).board(taxiId),
      child: const Text('Board passenger'),
    ),
    (QueueStatus.full, false) => FilledButton(
      onPressed: () =>
          ref.read(selectedQueueProvider(routeId).notifier).depart(taxiId),
      child: const Text('Depart'),
    ),
    (QueueStatus.waiting, true) ||
    (QueueStatus.waiting, false) ||
    (QueueStatus.loading, false) ||
    (QueueStatus.full, true) ||
    (QueueStatus.unknown, true) ||
    (QueueStatus.unknown, false) => null,
  };
}
