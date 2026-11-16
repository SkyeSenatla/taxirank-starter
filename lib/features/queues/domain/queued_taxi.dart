import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taxirank/core/money/cents.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';

part 'queued_taxi.freezed.dart';

/// One taxi in a route's queue.
@freezed
abstract class QueuedTaxi with _$QueuedTaxi {
  /// Creates a taxi.
  const factory({
    required String id,
    required String registration,
    required String driverName,
    required QueueStatus status,
    required int seatsTaken,
    required Cents collected,
    required int position,
  }) = _QueuedTaxi;
}
