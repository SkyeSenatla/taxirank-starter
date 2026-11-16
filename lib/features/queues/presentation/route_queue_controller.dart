import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/features/queues/data/queue_repository_provider.dart';
import 'package:taxirank/features/queues/domain/queue_repository.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';

part 'route_queue_controller.g.dart';

/// Loads and updates the queue for one route.
@riverpod
class RouteQueueController extends _$RouteQueueController {
  @override
  Future<RouteQueue> build(String routeId) =>
      ref.watch(queueRepositoryProvider).fetchQueue(routeId);

  /// Boards one passenger and replaces the taxi with the server's response.
  Future<void> board(String taxiId) => _updateQueue((repository, queue) async {
    final updated = await repository.board(queue.routeId, taxiId);
    return queue.copyWith(
      taxis: [
        for (final taxi in queue.taxis)
          if (taxi.id == taxiId) updated else taxi,
      ],
    );
  });

  /// Sends a full taxi off and reads the new order from the server.
  Future<void> depart(String taxiId) => _updateQueue((repository, queue) async {
    await repository.depart(queue.routeId, taxiId);
    return repository.fetchQueue(queue.routeId);
  });

  Future<void> _updateQueue(
    Future<RouteQueue> Function(QueueRepository, RouteQueue) update,
  ) async {
    final queue = state.asData?.value;
    if (queue == null || state.isLoading) return;

    final activeRef = ref;
    final repository = activeRef.read(queueRepositoryProvider);
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() => update(repository, queue));
    if (activeRef.mounted) state = result;
  }
}