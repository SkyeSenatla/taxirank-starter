import 'package:taxirank/features/queues/domain/queued_taxi.dart';

/// Details returned for one taxi independently of a previously opened queue.
final class TaxiDetails {
  /// Creates a taxi detail from the API's response.
  const TaxiDetails({
    required this.routeId,
    required this.routeName,
    required this.capacity,
    required this.taxi,
  });

  /// Which route owns this taxi.
  final String routeId;

  /// Name of that route.
  final String routeName;

  /// Number of seats in each taxi.
  final int capacity;

  /// The taxi returned by the server.
  final QueuedTaxi taxi;
}
