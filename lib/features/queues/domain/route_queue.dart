import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taxirank/core/money/cents.dart';
import 'package:taxirank/features/queues/domain/queued_taxi.dart';

part 'route_queue.freezed.dart';

/// A route from the rank, and its taxis in queue order.
@freezed
abstract class RouteQueue with _$RouteQueue {
  /// Creates a queue.
  const factory({
    required String routeId,
    required String routeName,
    required Cents fare,
    required int capacity,
    required List<QueuedTaxi> taxis,
  }) = _RouteQueue;
}
