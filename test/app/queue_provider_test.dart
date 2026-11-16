import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/app/retry_policy.dart';
import 'package:taxirank/core/fakes/rank_server.dart';
import 'package:taxirank/core/fakes/rank_server_provider.dart';
import 'package:taxirank/features/queues/presentation/selected_queue_controller.dart';

void main() {
  test('queue family keeps two route IDs separate', () async {
    final container = ProviderContainer(
      overrides: [
        rankServerProvider.overrideWithValue(
          RankServer(latency: Duration.zero),
        ),
      ],
      retry: appRetryPolicy,
    );
    addTearDown(container.dispose);

    final soweto = await container.read(selectedQueueProvider('soweto').future);
    final alex = await container.read(selectedQueueProvider('alex').future);
    expect(soweto.taxis.map((taxi) => taxi.id), contains('tx-102'));
    expect(alex.taxis.map((taxi) => taxi.id), isNot(contains('tx-102')));

    await container
        .read(selectedQueueProvider('soweto').notifier)
        .board('tx-102');
    final after = container.read(selectedQueueProvider('soweto')).value!;
    expect(after.taxis[1].collected.value, 24050);
    expect(container.read(selectedQueueProvider('alex')).value!.taxis.length, 3);
  });
}
