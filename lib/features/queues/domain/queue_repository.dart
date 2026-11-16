import 'package:taxirank/features/queues/domain/queued_taxi.dart';
import 'package:taxirank/features/queues/domain/rank_route.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';
import 'package:taxirank/features/queues/domain/taxi_details.dart';

/// The application-facing contract for the queues feature.
abstract interface class QueueRepository {
  /// Every route.
  Future<List<RankRoute>> fetchRoutes();

  /// The requested queue (or a RankNotFound error).
  Future<RouteQueue> fetchQueue(String routeId);

  /// Fetch just one taxi, given its two address IDs.
  Future<TaxiDetails> fetchTaxi(String routeId, String taxiId);

  /// Board exactly one passenger; the server has already counted the fare.
  Future<QueuedTaxi> board(String routeId, String taxiId);

  /// Send a full taxi off; the server adjusts the queue and departures.
  Future<void> depart(String routeId, String taxiId);
}
