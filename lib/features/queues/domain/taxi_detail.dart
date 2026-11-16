import 'package:taxirank/features/queues/domain/queued_taxi.dart';

/// One taxi, with its route's name and the seats in it.
final class TaxiDetail {
  /// Creates the detail.
  const new({
    required this.taxi,
    required this.routeName,
    required this.capacity,
  });

  /// The taxi, as the server has it.
  final QueuedTaxi taxi;

  /// The route's name.
  final String routeName;

  /// Seats in the taxi.
  final int capacity;
}
