import 'package:taxirank/features/queues/domain/queued_taxi.dart';
import 'package:taxirank/features/queues/domain/rank_route.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';

/// What the Queues tab needs from the rank server.
abstract interface class QueueRepository {
  /// Every route from the rank.
  Future<List<RankRoute>> fetchRoutes();

  /// One route's queue. A `RankNotFound` for a route that doesn't exist.
  Future<RouteQueue> fetchQueue(String routeId);

  /// One passenger boards [taxiId]. Returns the taxi as the server now has
  /// it.
  Future<QueuedTaxi> board(String routeId, String taxiId);
}
