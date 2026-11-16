import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/features/queues/data/queue_repository_provider.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';

part 'selected_queue_controller.g.dart';

/// The queue on screen. One for the whole app, loaded by whichever queue
/// screen opens.
///
/// Each route now has its own independent queue state.
@riverpod
class SelectedQueue extends _$SelectedQueue {
  @override
  Future<RouteQueue> build(String routeId) async {
    return await ref.read(queueRepositoryProvider).fetchQueue(routeId);
  }

  /// Loads the current route's queue again.
  Future<void> retry() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(queueRepositoryProvider).fetchQueue(routeId),
    );
  }

  /// One passenger boards [taxiId].
  Future<void> board(String taxiId) async {
    final queue = state.requireValue;

    final updated = await ref
        .read(queueRepositoryProvider)
        .board(queue.routeId, taxiId);

    state = AsyncData(
      queue.copyWith(
        taxis: [
          for (final taxi in queue.taxis)
            if (taxi.id == taxiId)
              // The server has already counted the fare.
              updated
            else
              taxi,
        ],
      ),
    );
  }
}
