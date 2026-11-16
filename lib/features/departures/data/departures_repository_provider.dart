import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/core/fakes/rank_server_provider.dart';
import 'package:taxirank/features/departures/data/server_departures_repository.dart';
import 'package:taxirank/features/departures/domain/departures_repository.dart';

part 'departures_repository_provider.g.dart';

/// Chooses the adapter outside the UI layer.
@Riverpod(keepAlive: true)
DeparturesRepository departuresRepository(Ref ref) =>
    ServerDeparturesRepository(ref.watch(rankServerProvider));
