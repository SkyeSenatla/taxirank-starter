import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/features/departures/presentation/departures_provider.dart';
import 'package:taxirank/features/queues/data/queue_repository_provider.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';
import 'package:taxirank/features/queues/presentation/routes_provider.dart';

part 'selected_queue_controller.g.dart';

/// A separate state instance per route ID. Navigating to another route cannot
/// temporarily display the previous route's taxi registrations.
@Riverpod(keepAlive: true)
class SelectedQueue extends _$SelectedQueue {
  bool _actionBusy = false;

  @override
  Future<RouteQueue> build(String routeId) =>
      ref.watch(queueRepositoryProvider).fetchQueue(routeId);

  /// The server already added the fare. Never add it a second time.
  Future<void> board(String taxiId) async {
    if (_actionBusy) return;
    final current = state.value;
    if (current == null) return;
    _actionBusy = true;
    try {
      final updated = await ref
          .read(queueRepositoryProvider)
          .board(routeId, taxiId);
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          taxis: [
            for (final taxi in current.taxis)
              if (taxi.id == taxiId) updated else taxi,
          ],
        ),
      );
    } finally {
      _actionBusy = false;
    }
  }

  /// Refresh all views affected by the server's departure operation.
  Future<void> depart(String taxiId) async {
    if (_actionBusy) return;
    _actionBusy = true;
    try {
      await ref.read(queueRepositoryProvider).depart(routeId, taxiId);
      if (!ref.mounted) return;
      ref
        ..invalidate(routesProvider)
        ..invalidate(departuresProvider)
        ..invalidateSelf();
    } finally {
      _actionBusy = false;
    }
  }
}
