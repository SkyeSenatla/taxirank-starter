import 'package:taxirank/features/queues/domain/queue_status.dart';

/// The only actions a marshal can take for a taxi.
enum TaxiAction { none, board, depart }

/// The rule is exhaustive over the status. Only Loading with room can board;
/// only Full can depart. Other states have no action.
TaxiAction actionFor(QueueStatus status, bool hasFreeSeat) =>
    switch ((status, hasFreeSeat)) {
      (QueueStatus.waiting, _) => TaxiAction.none,
      (QueueStatus.loading, true) => TaxiAction.board,
      (QueueStatus.loading, false) => TaxiAction.none,
      (QueueStatus.full, _) => TaxiAction.depart,
      (QueueStatus.unknown, _) => TaxiAction.none,
    };
