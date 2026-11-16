import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/features/queues/data/queue_repository_provider.dart';
import 'package:taxirank/features/queues/domain/taxi_details.dart';

part 'taxi_details_provider.g.dart';

/// A taxi loads from its route and taxi IDs, never a passed-in object.
@riverpod
Future<TaxiDetails> taxiDetails(Ref ref, String routeId, String taxiId) =>
    ref.watch(queueRepositoryProvider).fetchTaxi(routeId, taxiId);
