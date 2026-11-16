import 'package:intl/intl.dart';
import 'package:taxirank/core/money/cents.dart';

/// A single departure in the order supplied by the server.
final class Departure {
  /// Creates a departure with server-supplied facts.
  const Departure({
    required this.id,
    required this.taxiId,
    required this.registration,
    required this.routeId,
    required this.routeName,
    required this.departedAt,
    required this.passengers,
    required this.takings,
  });

  /// Departure ID.
  final String id;

  /// Taxi ID.
  final String taxiId;

  /// Taxi registration.
  final String registration;

  /// Route ID.
  final String routeId;

  /// Route display name.
  final String routeName;

  /// The actual instant in UTC.
  final DateTime departedAt;

  /// Number of passengers, as counted by the backend.
  final int passengers;

  /// Server-calculated takings in whole cents.
  final Cents takings;

  /// The rank uses UTC+2 year-round; never use the phone's local zone.
  String get southAfricanTime => DateFormat('HH:mm').format(
    departedAt.toUtc().add(const Duration(hours: 2)),
  );
}
