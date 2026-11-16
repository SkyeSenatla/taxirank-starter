import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/core/money/format_rands.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';
import 'package:taxirank/features/queues/presentation/queue_view_state.dart';
import 'package:taxirank/features/queues/presentation/route_queue_controller.dart';

/// One route's queue, for the marshal.
class RouteQueueScreen extends ConsumerWidget {
  /// Creates the screen for [routeId].
  const new({required this.routeId, super.key});

  /// The route in the address.
  final String routeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = routeQueueControllerProvider(routeId);
    final queue = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(title: Text(queue.value?.routeName ?? 'Queue')),
      body: switch (QueueViewState.fromAsync(queue)) {
        QueueLoading() => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Loading queue…'),
            ],
          ),
        ),
        QueueEmpty() => const _QueueMessage(
          message: 'No taxis waiting on this route.',
        ),
        QueueData(:final queue) => _QueueList(queue: queue),
        QueueFailure(:final reference) => _QueueMessage(
          message: "We couldn't load this queue.",
          reference: reference,
          onRetry: () => ref.invalidate(provider),
        ),
        QueueNotFound(:final reference) => _QueueMessage(
          message: 'Route not found.',
          reference: reference,
        ),
      },
    );
  }
}

class _QueueMessage extends StatelessWidget {
  const new({required this.message, this.reference, this.onRetry});

  final String message;
  final String? reference;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            if (reference != null) Text('Reference: $reference'),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ],
        ),
      ),
    );
  }
}

class _QueueList extends ConsumerWidget {
  const new({required this.queue});

  final RouteQueue queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = routeQueueControllerProvider(queue.routeId);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final taxi in queue.taxis)
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _colour(taxi.status),
                child: Text('${taxi.position}'),
              ),
              title: Text(taxi.registration),
              isThreeLine: true,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(taxi.status.label),
                  Text(
                    '${taxi.driverName} · '
                    '${taxi.seatsTaken} of ${queue.capacity} seats · '
                    '${formatRands(taxi.collected)}',
                  ),
                ],
              ),
              trailing: switch (taxi.status.action(
                hasFreeSeat: taxi.seatsTaken < queue.capacity,
              )) {
                TaxiAction.board => FilledButton(
                  onPressed: () => ref.read(provider.notifier).board(taxi.id),
                  child: const Text('Board passenger'),
                ),
                TaxiAction.depart => FilledButton(
                  onPressed: () => ref.read(provider.notifier).depart(taxi.id),
                  child: const Text('Depart'),
                ),
                TaxiAction.none => null,
              },
            ),
          ),
      ],
    );
  }

  Color _colour(QueueStatus status) => switch (status) {
    QueueStatus.loading => const Color(0xFF2E7D32),
    _ => const Color(0xFF9E9E9E),
  };
}