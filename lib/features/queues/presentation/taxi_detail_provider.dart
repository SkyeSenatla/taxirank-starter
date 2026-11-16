import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/features/queues/data/queue_repository_provider.dart';
import 'package:taxirank/features/queues/domain/queued_taxi.dart';

part 'taxi_detail_provider.g.dart';

/// A taxi lookup scoped to both route and taxi identifiers.
@riverpod
Future<QueuedTaxi> taxiDetail(Ref ref, String routeId, String taxiId) =>
    ref.watch(queueRepositoryProvider).fetchTaxi(routeId, taxiId);
