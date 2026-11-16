import 'package:taxirank/features/queues/domain/queue_status.dart';

enum TaxiAction {
  board, depart, none,}

  TaxiAction actionFor({required QueueStatus status, required bool seatFree}) =>
    switch ((status, seatFree)) {
      (QueueStatus.loading, true) => TaxiAction.board,
      (QueueStatus.loading, false) => TaxiAction.none,
      (QueueStatus.full, _) => TaxiAction.depart,
      (QueueStatus.waiting, _) => TaxiAction.none,
      (QueueStatus.unknown, _) => TaxiAction.none,
    };