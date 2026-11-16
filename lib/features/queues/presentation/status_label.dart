import 'package:taxirank/features/queues/domain/queue_status.dart';

/// Every status in words, from one exhaustive switch.
// NEW: no wildcard, so adding a status later is a compile error here.
String statusLabel(QueueStatus status) => switch (status) {
  QueueStatus.waiting => 'Waiting',
  QueueStatus.loading => 'Loading',
  QueueStatus.full => 'Full',
  QueueStatus.unknown => 'Status not recognised',
};
