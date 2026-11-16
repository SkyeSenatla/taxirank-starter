import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';

void main() {
  group('QueueStatus.fromWire', () {
    test('maps known statuses case-insensitively', () {
      expect(QueueStatus.fromWire('Waiting'), QueueStatus.waiting);
      expect(QueueStatus.fromWire('LOADING'), QueueStatus.loading);
      expect(QueueStatus.fromWire('Full'), QueueStatus.full);
    });
    test('maps unknown statuses safely', () {
      expect(QueueStatus.fromWire('OffDuty'), QueueStatus.unknown);
      expect(QueueStatus.fromWire('future-status'), QueueStatus.unknown);
    });
  });
}
