import 'package:taxirank/core/fakes/rank_server.dart';
import 'package:taxirank/core/money/cents.dart';
import 'package:taxirank/features/queues/domain/queue_repository.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';
import 'package:taxirank/features/queues/domain/queued_taxi.dart';
import 'package:taxirank/features/queues/domain/rank_route.dart';
import 'package:taxirank/features/queues/domain/route_queue.dart';

/// The queues, from the rank server's wire answers.
final class ServerQueueRepository implements QueueRepository {
  /// Creates the repository over [server].
  const new(this.server);

  /// The rank server.
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
  Future<QueuedTaxi> board(String routeId, String taxiId) async =>
      taxiFromWire(await server.board(routeId, taxiId));

  /// One taxi from the server's wire form.
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
