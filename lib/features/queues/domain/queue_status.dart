/// Where a taxi is in the queue, as the rank server spells it.
enum QueueStatus {
  /// In the queue, not taking passengers yet.
  waiting,

  /// At the front, taking passengers.
  loading,

  /// Every seat taken: ready to depart.
  full,

  /// A status not recognised by the application.
  unknown;

  /// Maps the server's string to a status.
  static QueueStatus fromWire(String value) => switch (value) {
    'Waiting' => QueueStatus.waiting,
    'Loading' => QueueStatus.loading,
    'Full' => QueueStatus.full,
    _ => QueueStatus.unknown,
  };

  /// Displays the taxi status in words for the marshal.
  String get label => switch (this) {
    QueueStatus.waiting => 'Waiting',
    QueueStatus.loading => 'Loading',
    QueueStatus.full => 'Full',
    QueueStatus.unknown => 'Status not recognised',
  };
}
