/// Where a taxi is in the queue, as the rank server spells it.
enum QueueStatus {
  /// In the queue, not taking passengers yet.
  waiting,

  /// At the front, taking passengers.
  loading,

  /// Every seat taken: ready to depart.
  full,

  unknown;

  static QueueStatus fromWire(String value) => switch (value) {
    'Waiting' => QueueStatus.waiting,
    'Loading' => QueueStatus.loading,
    'Full' => QueueStatus.full,
    _ => QueueStatus.unknown,
  };

  String get label => switch (this) {
    QueueStatus.waiting => 'Waiting',
    QueueStatus.loading => 'Loading',
    QueueStatus.full => 'Full',
    QueueStatus.unknown => 'Status not known',
  };

  TaxiAction action({required bool hasFreeSeat}) =>
      switch ((this, hasFreeSeat)) {
        (QueueStatus.waiting, _) => TaxiAction.none,
        (QueueStatus.loading, true) => TaxiAction.board,
        (QueueStatus.loading, false) => TaxiAction.none,
        (QueueStatus.full, _) => TaxiAction.depart,
        (QueueStatus.unknown, _) => TaxiAction.none,
      };
}

enum TaxiAction { board, depart, none }
