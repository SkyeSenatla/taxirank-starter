import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/core/fakes/rank_server.dart';
import 'package:taxirank/features/departures/data/server_departures_repository.dart';

void main() {
  test('maps the server order and its values, converting time to SAST', () async {
    final repository = ServerDeparturesRepository(
      RankServer(latency: Duration.zero),
    );
    final result = await repository.fetchDepartures();
    expect(result.first.registration, 'GP 640-221');
    expect(result.first.southAfricanTime, '08:42');
    expect(result.first.passengers, 15);
    expect(result.first.takings.value, 27750);
  });

  test('an empty server returns an empty domain list', () async {
    final repository = ServerDeparturesRepository(
      RankServer(latency: Duration.zero, departures: []),
    );
    expect(await repository.fetchDepartures(), isEmpty);
  });
}
