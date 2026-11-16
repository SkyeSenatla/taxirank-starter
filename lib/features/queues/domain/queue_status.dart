/// Where a taxi is in the queue, as the rank server spells it.
enum QueueStatus {
  /// In the queue, not taking passengers yet.
  waiting,

  /// At the front, taking passengers.
  loading,

  /// Every seat taken: ready to depart.
  full;

  /// Maps the server's string to a status.
  static QueueStatus fromWire(String value) =>
      QueueStatus.values.byName(value.toLowerCase());
}
