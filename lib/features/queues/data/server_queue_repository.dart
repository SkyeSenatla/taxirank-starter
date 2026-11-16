import 'package:taxirank/core/fakes/rank_server.dart';
import 'package:taxirank/core/money/cents.dart';
import 'package:taxirank/features/queues/domain/queue_repository.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';
import 'package:taxirank/features/queues/domain/queued_taxi.dart';
import 'package:taxirank/features/queues/domain/rank_route.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';
import 'package:taxirank/features/queues/domain/taxi_details.dart';

/// Maps the backend's wire maps into the app's domain objects.
final class ServerQueueRepository implements QueueRepository {
  /// Creates the adapter over the existing server.
  const ServerQueueRepository(this.server);

  /// The unchanged backend.
  final RankServer server;

  @override
  Future<List<RankRoute>> fetchRoutes() async => [
    for (final r in await server.getRoutes())
      RankRoute(
        id: r['id']! as String,
        name: r['name']! as String,
        fare: Cents(r['fareCents']! as int),
        queueLength: r['queueLength']! as int,
      ),
  ];

  @override
  Future<RouteQueue> fetchQueue(String routeId) async {
    final q = await server.getQueue(routeId);
    return RouteQueue(
      routeId: q['routeId']! as String,
      routeName: q['routeName']! as String,
      fare: Cents(q['fareCents']! as int),
      capacity: q['capacity']! as int,
      taxis: [
        for (final t in q['taxis']! as List<Object?>)
          taxiFromWire(t! as Map<String, Object?>),
      ],
    );
  }

  @override
  Future<TaxiDetails> fetchTaxi(String routeId, String taxiId) async {
    final response = await server.getTaxi(routeId, taxiId);
    return TaxiDetails(
      routeId: response['routeId']! as String,
      routeName: response['routeName']! as String,
      capacity: response['capacity']! as int,
      taxi: taxiFromWire(response),
    );
  }

  @override
  Future<QueuedTaxi> board(String routeId, String taxiId) async =>
      taxiFromWire(await server.board(routeId, taxiId));

  @override
  Future<void> depart(String routeId, String taxiId) async {
    await server.depart(routeId, taxiId);
  }

  /// Preserve the authoritative seat count, collected cents and position.
  static QueuedTaxi taxiFromWire(Map<String, Object?> t) => QueuedTaxi(
    id: t['id']! as String,
    registration: t['registration']! as String,
    driverName: t['driverName']! as String,
    status: QueueStatus.fromWire(t['status']! as String),
    seatsTaken: t['seatsTaken']! as int,
    collected: Cents(t['collectedCents']! as int),
    position: t['position']! as int,
  );
}
