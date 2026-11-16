import 'package:taxirank/features/departures/domain/departure.dart';

abstract interface class DepartureRepository {
    Future<List<Departure>> fetchToday();
}