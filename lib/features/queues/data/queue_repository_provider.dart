import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/core/fakes/rank_server_provider.dart';
import 'package:taxirank/features/queues/data/server_queue_repository.dart';
import 'package:taxirank/features/queues/domain/queue_repository.dart';

part 'queue_repository_provider.g.dart';

/// The one place that names the queues implementation.
@Riverpod(keepAlive: true)
QueueRepository queueRepository(Ref ref) =>
    ServerQueueRepository(ref.watch(rankServerProvider));
