import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/core/money/format_rands.dart';
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
  void initState() {
    super.initState();
    unawaited(
      Future.microtask(
        () => ref.read(selectedQueueProvider.notifier).load(widget.routeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(selectedQueueProvider);
    return Scaffold(
      appBar: AppBar(title: Text(queue.value?.routeName ?? 'Queue')),
      body: queue.when(
        data: (q) => q == null
            ? const Center(child: CircularProgressIndicator())
            : _QueueList(queue: q),
        error: (e, _) => Center(child: Text('$e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _QueueList extends ConsumerWidget {
  const new({required this.queue});

  final RouteQueue queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              subtitle: Text(
                '${taxi.driverName} · '
                '${taxi.seatsTaken} of ${queue.capacity} seats · '
                '${formatRands(taxi.collected)}',
              ),
              trailing: taxi.status == QueueStatus.loading
                  ? FilledButton(
                      onPressed: () => ref
                          .read(selectedQueueProvider.notifier)
                          .board(taxi.id),
                      child: const Text('Board passenger'),
                    )
                  : null,
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
