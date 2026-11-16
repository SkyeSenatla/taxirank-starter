import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/core/money/format_rands.dart';
import 'package:taxirank/features/queues/domain/queue_action.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';
import 'package:taxirank/features/queues/presentation/selected_queue_controller.dart';

/// One route's queue, for the marshal.
class RouteQueueScreen extends ConsumerStatefulWidget {
  /// Creates the screen for [routeId].
  const new({required this.routeId, super.key});

  /// The route in the address.
  final String routeId;

  @override
  ConsumerState<RouteQueueScreen> createState() => _RouteQueueScreenState();
}

class _RouteQueueScreenState extends ConsumerState<RouteQueueScreen> {
  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(selectedQueueProvider(widget.routeId));
    return Scaffold(
      appBar: AppBar(title: Text(queue.value?.routeName ?? 'Queue')),
      body: queue.when(
        data: (q) => _QueueList(queue: q, routeId: widget.routeId),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load this queue.'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref
                    .read(selectedQueueProvider(widget.routeId).notifier)
                    .retry(),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _QueueList extends ConsumerWidget {
  const new({required this.queue, required this.routeId});

  final RouteQueue queue;
  final String routeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
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
                '${taxi.driverName} · '
                '${taxi.seatsTaken} of ${queue.capacity} seats · '
                '${formatRands(taxi.collected)}',
              ),
              trailing:
                  allowedAction(
                        taxi.status,
                        hasFreeSeat: taxi.seatsTaken < queue.capacity,
                      ) ==
                      QueueAction.board
                  ? FilledButton(
                      onPressed: () => ref
                          .read(selectedQueueProvider(routeId).notifier)
                          .board(taxi.id),
                      child: const Text('Board passenger'),
                    )
                  : null,
            ),
          ),
      ],
    );
  }

  Color _colour(BuildContext context, QueueStatus status) {
    final colors = Theme.of(context).colorScheme;

    return switch (status) {
      QueueStatus.loading => colors.primary,
      QueueStatus.waiting => colors.secondary,
      QueueStatus.full => colors.tertiary,
      QueueStatus.unknown => colors.outline,
    };
  }
}
