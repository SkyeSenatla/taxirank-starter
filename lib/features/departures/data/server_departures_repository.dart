import 'package:taxirank/core/fakes/rank_server.dart';
import 'package:taxirank/core/money/cents.dart';
import 'package:taxirank/features/departures/domain/departure.dart';
import 'package:taxirank/features/departures/domain/departures_repository.dart';

/// Translates the rank's wire representation to a domain list.
final class ServerDeparturesRepository implements DeparturesRepository {
  /// Creates an adapter to the existing server.
  const ServerDeparturesRepository(this.server);

  /// The server is authoritative for order, passengers and takings.
  final RankServer server;

  @override
  Future<List<Departure>> fetchDepartures() async => [
    for (final d in await server.getDepartures())
      Departure(
        id: d['id']! as String,
        taxiId: d['taxiId']! as String,
        registration: d['registration']! as String,
        routeId: d['routeId']! as String,
        routeName: d['routeName']! as String,
        departedAt: DateTime.parse(d['departedAt']! as String).toUtc(),
        passengers: d['passengers']! as int,
        takings: Cents(d['takingsCents']! as int),
      ),
  ];
}
