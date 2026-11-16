import 'package:taxirank/features/queues/domain/queue_status.dart';

/// An action the marshal may perform on a taxi.
enum QueueAction {
  /// Board one passenger onto the loading taxi.
  board,

  /// Send a full taxi off the rank.
  depart,

  /// No action is currently permitted.
  none,
}

/// Determines the action allowed for a taxi.
QueueAction allowedAction(QueueStatus status, {required bool hasFreeSeat}) =>
    switch ((status, hasFreeSeat)) {
      (QueueStatus.loading, true) => QueueAction.board,
      (QueueStatus.loading, false) => QueueAction.none,
      (QueueStatus.full, true) => QueueAction.depart,
      (QueueStatus.full, false) => QueueAction.depart,
      (QueueStatus.waiting, _) => QueueAction.none,
      (QueueStatus.unknown, _) => QueueAction.none,
    };
