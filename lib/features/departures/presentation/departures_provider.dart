import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/core/fakes/rank_server_provider.dart';
import 'package:taxirank/features/departures/data/departures_repository.dart';
import 'package:taxirank/features/departures/domain/departure.dart';
part 'departures_provider.g.dart';

/// Today's departures, newest first as the server returns them.
@riverpod
Future<List<Departure>> todayDepartures(Ref ref) =>
    DeparturesRepository(ref.watch(rankServerProvider)).fetchToday();
