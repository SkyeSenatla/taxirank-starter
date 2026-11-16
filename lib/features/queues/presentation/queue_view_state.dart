import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/core/errors/rank_errors.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';

sealed class QueueViewState {
  const new();

  factory QueueViewState.fromAsync(AsyncValue<RouteQueue> value) =>
      switch (value) {
        AsyncLoading() ||
        AsyncValue(isLoading: true) ||
        AsyncValue(retrying: true) => const QueueLoading(),
        AsyncData(:final value) when value.taxis.isEmpty => const QueueEmpty(),
        AsyncData(:final value) => QueueData(value),
        AsyncError(error: RankNotFound(:final reference)) => QueueNotFound(
          reference,
        ),
        AsyncError(error: RankError(:final reference)) => QueueFailure(
          reference,
        ),
        AsyncError() => const QueueFailure(null),
      };
}

final class QueueLoading extends QueueViewState {
  const new();
}

final class QueueEmpty extends QueueViewState {
  const new();
}

final class QueueData extends QueueViewState {
  const new(this.queue);

  final RouteQueue queue;
}

final class QueueFailure extends QueueViewState {
  const new(this.reference);

  final String? reference;
}

final class QueueNotFound extends QueueViewState {
  const new(this.reference);

  final String reference;
}