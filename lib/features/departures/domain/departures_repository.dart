import 'package:taxirank/features/departures/domain/departure.dart';

/// Data access contract for today's departures.
abstract interface class DeparturesRepository {
  /// Returns today's departures, newest first as the server sends them.
  Future<List<Departure>> fetchDepartures();
}
