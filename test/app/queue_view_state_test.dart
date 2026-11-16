import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/core/errors/rank_errors.dart';
import 'package:taxirank/core/money/cents.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';
import 'package:taxirank/features/queues/presentation/queue_view_state.dart';

void main() {
  test('sealed view state distinguishes empty, missing, and network failure', () {
    final queue = RouteQueue(
      routeId: 'randburg',
      routeName: 'Randburg',
      fare: Cents(1750),
      capacity: 15,
      taxis: const [],
    );
    expect(queueViewState(const AsyncLoading()), isA<QueueLoading>());
    expect(queueViewState(AsyncData(queue)), isA<QueueEmpty>());
    expect(
      queueViewState(
        AsyncError(const RankNotFound('Not found', 'TR-404'), StackTrace.empty),
      ),
      isA<QueueNotFound>(),
    );
    final failed = queueViewState(
      AsyncError(
        const RankUnavailable('Offline', 'TR-503'),
        StackTrace.empty,
      ),
    );
    expect(failed, isA<QueueFailure>());
    expect((failed as QueueFailure).reference, 'TR-503');
  });
}
