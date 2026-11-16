/// A known queue status, or a future status the server has introduced.
enum QueueStatus {
  /// Waiting for its turn.
  waiting,

  /// Boarding passengers.
  loading,

  /// Ready to depart.
  full,

  /// A status this version of the app does not yet recognise.
  unknown;

  /// Server values are case-sensitive: do not silently accept `loading`.
  static QueueStatus fromWire(String value) => switch (value) {
    'Waiting' => QueueStatus.waiting,
    'Loading' => QueueStatus.loading,
    'Full' => QueueStatus.full,
    _ => QueueStatus.unknown,
  };

  /// Every status has a visible, accessible text label.
  String get label => switch (this) {
    QueueStatus.waiting => 'Waiting',
    QueueStatus.loading => 'Loading',
    QueueStatus.full => 'Full',
    QueueStatus.unknown => 'Status not recognised',
  };
}
