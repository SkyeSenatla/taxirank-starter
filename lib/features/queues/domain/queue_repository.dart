import 'package:taxirank/features/queues/domain/queued_taxi.dart';
import 'package:taxirank/features/queues/domain/rank_route.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';

/// What the Queues tab needs from the rank server.
abstract interface class QueueRepository {
  /// Every route from the rank.
  Future<List<RankRoute>> fetchRoutes();

  /// One route's queue. A `RankNotFound` for a route that doesn't exist.
  Future<RouteQueue> fetchQueue(String routeId);

  /// One taxi on [routeId], or not found when it is on another route.
  Future<QueuedTaxi> fetchTaxi(String routeId, String taxiId);

  /// One passenger boards [taxiId]. Returns the taxi as the server now has
  /// it.
  Future<QueuedTaxi> board(String routeId, String taxiId);

  /// A full taxi leaves [routeId]'s queue.
  Future<void> depart(String routeId, String taxiId);
}
