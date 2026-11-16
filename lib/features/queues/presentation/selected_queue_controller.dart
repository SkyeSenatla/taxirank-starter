import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/features/queues/data/queue_repository_provider.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';

part 'selected_queue_controller.g.dart';

/// One independently cached queue for each route id.
@Riverpod(keepAlive: true)
class SelectedQueue extends _$SelectedQueue {
  @override
  Future<RouteQueue> build(String routeId) =>
      ref.watch(queueRepositoryProvider).fetchQueue(routeId);

  /// One passenger boards [taxiId]; the server supplies the updated totals.
  Future<void> board(String taxiId) async {
    final queue = state.asData?.value;
    if (queue == null) return;
    state = await AsyncValue.guard(() async {
      final updated = await ref
          .read(queueRepositoryProvider)
          .board(routeId, taxiId);
      return queue.copyWith(
        taxis: [
          for (final taxi in queue.taxis)
            if (taxi.id == taxiId) updated else taxi,
        ],
      );
    });
  }

  /// A full taxi departs; the server determines the new queue order.
  Future<void> depart(String taxiId) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(queueRepositoryProvider);
      await repository.depart(routeId, taxiId);
      return repository.fetchQueue(routeId);
    });
  }
}
