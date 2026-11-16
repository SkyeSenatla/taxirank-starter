import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/features/departures/data/departures_repository_provider.dart';
import 'package:taxirank/features/departures/domain/departure.dart';

part 'departures_provider.g.dart';

/// Fetches the list in server order, keeping it while switching tabs.
@Riverpod(keepAlive: true)
Future<List<Departure>> departures(Ref ref) =>
    ref.watch(departuresRepositoryProvider).fetchDepartures();
