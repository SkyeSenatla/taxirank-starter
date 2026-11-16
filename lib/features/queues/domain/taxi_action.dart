import 'package:taxirank/features/queues/domain/queue_status.dart';

/// What the marshal may do to a taxi.
enum TaxiAction {
  /// Board one passenger.
  board,

  /// Send the taxi off.
  depart,

  /// Nothing.
  none,
}

/// The marshal's action for a taxi, from its status and whether a seat is
/// free.
// NEW: one exhaustive match on a record. No wildcard over the status.
TaxiAction actionFor(QueueStatus status, {required bool seatFree}) =>
    switch ((status, seatFree)) {
      (QueueStatus.loading, true) => TaxiAction.board,
      (QueueStatus.loading, false) => TaxiAction.none,
      (QueueStatus.full, _) => TaxiAction.depart,
      (QueueStatus.waiting, _) => TaxiAction.none,
      (QueueStatus.unknown, _) => TaxiAction.none,
    };
