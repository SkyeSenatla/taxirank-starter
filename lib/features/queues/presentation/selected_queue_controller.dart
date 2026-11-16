import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/features/queues/data/queue_repository_provider.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';

part 'selected_queue_controller.g.dart';

/// The queue on screen. One for the whole app, loaded by whichever queue
/// screen opens.
@Riverpod(keepAlive: true)
class SelectedQueue extends _$SelectedQueue {
  /// The route that's on screen.
  String? routeId;

  @override
  Future<RouteQueue?> build() async => null;

  /// Loads [id]'s queue.
  Future<void> load(String id) async {
    routeId = id;
    final queue = await ref.read(queueRepositoryProvider).fetchQueue(id);
    state = AsyncData(queue);
  }

  /// One passenger boards [taxiId].
  Future<void> board(String taxiId) async {
    final queue = state.value!;
    final updated = await ref
        .read(queueRepositoryProvider)
        .board(queue.routeId, taxiId);
    state = AsyncData(
      queue.copyWith(
        taxis: [
          for (final taxi in queue.taxis)
            if (taxi.id == taxiId)
              // Count the fare straight away, so the marshal sees it.
              updated.copyWith(collected: updated.collected + queue.fare)
            else
              taxi,
        ],
      ),
    );
  }
}
