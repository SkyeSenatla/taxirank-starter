import 'package:taxirank/features/departures/domain/departure.dart';

/// What the Departures tab needs from the rank server.
abstract interface class DepartureRepository {
  /// Today's departures, newest first.
  Future<List<Departure>> fetchToday();
}
