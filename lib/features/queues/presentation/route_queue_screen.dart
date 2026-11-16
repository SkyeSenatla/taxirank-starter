import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/app/router/routes.dart';
import 'package:taxirank/app/theme/app_theme.dart';
import 'package:taxirank/core/errors/rank_errors.dart';
import 'package:taxirank/core/money/format_rands.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';
import 'package:taxirank/features/queues/domain/taxi_action.dart';
import 'package:taxirank/features/queues/domain/queued_taxi.dart';
import 'package:taxirank/features/queues/presentation/queue_view_state.dart';
import 'package:taxirank/features/queues/presentation/selected_queue_controller.dart';

/// A route-specific queue; no taxi from another route can appear here.
class RouteQueueScreen extends ConsumerWidget {
  /// Creates the screen from the URL's route ID.
  const RouteQueueScreen({required this.routeId, super.key});

  /// Address component used to select the provider family member.
  final String routeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = queueViewState(ref.watch(selectedQueueProvider(routeId)));
    final title = switch (state) {
      QueueEmpty(:final queue) || QueueData(:final queue) => queue.routeName,
      _ => 'Queue',
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: switch (state) {
        QueueLoading() => const Center(child: CircularProgressIndicator()),
        QueueNotFound() => const Center(child: Text('Route not found.')),
        QueueEmpty() => const Center(
          child: Text('No taxis waiting on this route.'),
        ),
        QueueData(:final queue) => _QueueList(
          key: ValueKey(queue.routeId),
          queue: queue,
        ),
        QueueFailure(:final reference) => _QueueFailed(
          reference: reference,
          onRetry: () => ref.invalidate(selectedQueueProvider(routeId)),
        ),
      },
    );
  }
}

class _QueueFailed extends StatelessWidget {
  const _QueueFailed({required this.reference, required this.onRetry});
  final String? reference;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("We couldn't load this queue."),
        if (reference != null) Text('Reference: $reference'),
        const SizedBox(height: 12),
        FilledButton.tonal(
          onPressed: onRetry,
          child: const Text('Try again'),
        ),
      ],
    ),
  );
}

class _QueueList extends ConsumerStatefulWidget {
  const _QueueList({required this.queue, super.key});
  final RouteQueue queue;

  @override
  ConsumerState<_QueueList> createState() => _QueueListState();
}

class _QueueListState extends ConsumerState<_QueueList> {
  String? _workingTaxiId;

  Future<void> _doAction(QueuedTaxi taxi, TaxiAction action) async {
    if (_workingTaxiId != null) return;
    setState(() => _workingTaxiId = taxi.id);
    try {
      final controller = ref.read(
        selectedQueueProvider(widget.queue.routeId).notifier,
      );
      final operation = switch (action) {
        TaxiAction.board => controller.board(taxi.id),
        TaxiAction.depart => controller.depart(taxi.id),
        TaxiAction.none => Future<void>.value(),
      };
      await operation;
    } on RankError catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${error.message} Reference: ${error.reference}')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action failed. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _workingTaxiId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColors = Theme.of(context).extension<RankStatusColors>()!;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final taxi in widget.queue.taxis)
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: statusColors.forStatus(taxi.status),
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      child: Text('${taxi.position}'),
                    ),
                    title: Text(taxi.registration),
                    subtitle: Text(
                      '${taxi.driverName} · '
                      '${taxi.seatsTaken} of ${widget.queue.capacity} seats · '
                      '${formatRands(taxi.collected)}',
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => TaxiDetailsRoute(
                      routeId: widget.queue.routeId,
                      taxiId: taxi.id,
                    ).go(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 12, 8),
                    child: Row(
                      children: [
                        Chip(
                          avatar: Icon(
                            Icons.circle,
                            size: 12,
                            color: statusColors.forStatus(taxi.status),
                          ),
                          label: Text(taxi.status.label),
                          backgroundColor: statusColors
                              .forStatus(taxi.status)
                              .withValues(alpha: 0.12),
                          side: BorderSide.none,
                        ),
                        const Spacer(),
                        if (_workingTaxiId == taxi.id)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          switch (actionFor(
                            taxi.status,
                            taxi.seatsTaken < widget.queue.capacity,
                          )) {
                            TaxiAction.board => FilledButton.tonal(
                              onPressed: _workingTaxiId == null
                                  ? () => _doAction(taxi, TaxiAction.board)
                                  : null,
                              child: const Text('Board passenger'),
                            ),
                            TaxiAction.depart => FilledButton(
                              onPressed: _workingTaxiId == null
                                  ? () => _doAction(taxi, TaxiAction.depart)
                                  : null,
                              child: const Text('Depart'),
                            ),
                            TaxiAction.none => const SizedBox.shrink(),
                          },
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
