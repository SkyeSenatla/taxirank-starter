import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/core/errors/rank_errors.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';

/// Screen states, one branch for every user-visible outcome.
sealed class QueueViewState {
  const QueueViewState();
}

/// Waiting for the server (or for an automatic retry).
final class QueueLoading extends QueueViewState {
  const QueueLoading();
}

/// An existing route with no taxis.
final class QueueEmpty extends QueueViewState {
  const QueueEmpty(this.queue);
  final RouteQueue queue;
}

/// An existing route with taxis.
final class QueueData extends QueueViewState {
  const QueueData(this.queue);
  final RouteQueue queue;
}

/// A definitive 404, not a network failure.
final class QueueNotFound extends QueueViewState {
  const QueueNotFound();
}

/// A failed request with an error reference (if provided by the server).
final class QueueFailure extends QueueViewState {
  const QueueFailure(this.error);
  final Object error;

  String? get reference => switch (error) {
    RankError(:final reference) => reference,
    _ => null,
  };
}

/// The presentation mapping keeps the screen independent of AsyncValue.
QueueViewState queueViewState(AsyncValue<RouteQueue> state) => switch (state) {
  AsyncData(:final value) when value.taxis.isEmpty => QueueEmpty(value),
  AsyncData(:final value) => QueueData(value),
  AsyncError(error: RankNotFound()) => const QueueNotFound(),
  AsyncError(:final error) => QueueFailure(error),
  _ => const QueueLoading(),
};
