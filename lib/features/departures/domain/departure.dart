import 'package:taxirank/core/money/cents.dart';

/// A taxi that departed today, as reported by the rank server.
class Departure {
  /// Creates a departure.
  const Departure({
    required this.id,
    required this.registration,
    required this.routeName,
    required this.departedAt,
    required this.passengers,
    required this.takings,
  });

  /// Server id.
  final String id;

  /// Taxi registration.
  final String registration;

  /// Route display name.
  final String routeName;

  /// Departure instant (UTC from the server).
  final DateTime departedAt;

  /// Passenger count supplied by the server.
  final int passengers;

  /// Takings supplied by the server.
  final Cents takings;
}
