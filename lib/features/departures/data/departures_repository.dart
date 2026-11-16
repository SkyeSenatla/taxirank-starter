import 'package:taxirank/core/fakes/rank_server.dart';
import 'package:taxirank/core/money/cents.dart';
import 'package:taxirank/features/departures/domain/departure.dart';

/// Reads today's departures from the rank server.
class DeparturesRepository {
  /// Creates the repository.
  const DeparturesRepository(this.server);

  /// Backend boundary.
  final RankServer server;

  /// Returns departures in the order supplied by the server.
  Future<List<Departure>> fetchToday() async => [
    for (final d in await server.getDepartures())
      Departure(
        id: d['id']! as String,
        registration: d['registration']! as String,
        routeName: d['routeName']! as String,
        departedAt: DateTime.parse(d['departedAt']! as String),
        passengers: d['passengers']! as int,
        takings: Cents(d['takingsCents']! as int),
      ),
  ];
}
