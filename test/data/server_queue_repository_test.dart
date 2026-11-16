import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/core/fakes/rank_server.dart';
import 'package:taxirank/features/queues/data/server_queue_repository.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';

void main() {
  test('a future status does not crash the route mapping', () async {
    final repository = ServerQueueRepository(
      RankServer(latency: Duration.zero),
    );
    final queue = await repository.fetchQueue('alex');
    expect(queue.taxis.length, 3);
    expect(queue.taxis[1].driverName, 'Zanele Khoza');
    expect(queue.taxis[1].status, QueueStatus.unknown);
  });

  test('boarding trusts the returned cents, without adding another fare', () async {
    final repository = ServerQueueRepository(
      RankServer(latency: Duration.zero),
    );
    final result = await repository.board('soweto', 'tx-102');
    expect(result.seatsTaken, 13);
    expect(result.collected.value, 24050);
  });

  test('departing uses server order and queue positions', () async {
    final repository = ServerQueueRepository(
      RankServer(latency: Duration.zero),
    );
    await repository.depart('soweto', 'tx-101');
    final queue = await repository.fetchQueue('soweto');
    expect(queue.taxis.map((taxi) => taxi.id).toList(), ['tx-102', 'tx-103']);
    expect(queue.taxis.map((taxi) => taxi.position).toList(), [1, 2]);
  });
}
