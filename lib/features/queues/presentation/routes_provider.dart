import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/features/queues/data/queue_repository_provider.dart';
import 'package:taxirank/features/queues/domain/rank_route.dart';

part 'routes_provider.g.dart';

/// Every route from the rank, for the Queues tab.
@riverpod
Future<List<RankRoute>> routes(Ref ref) =>
    ref.watch(queueRepositoryProvider).fetchRoutes();
