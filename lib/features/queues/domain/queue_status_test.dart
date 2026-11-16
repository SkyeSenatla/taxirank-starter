import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';
import 'package:taxirank/features/queues/presentation/status_label.dart';

void main() {
  group('QueueStatus.fromWire', () {
    test('Waiting', () {
      expect(QueueStatus.fromWire('Waiting'), QueueStatus.waiting);
    });
    test('Loading', () {
      expect(QueueStatus.fromWire('Loading'), QueueStatus.loading);
    });
    test('Full', () {
      expect(QueueStatus.fromWire('Full'), QueueStatus.full);
    });
    // The case the brief cares about: no crash on a new status.
    test('a status the server adds later is unknown, not a crash', () {
      expect(QueueStatus.fromWire('OffDuty'), QueueStatus.unknown);
    });
  });

  group('statusLabel', () {
    test('every status is in words', () {
      expect(statusLabel(QueueStatus.waiting), 'Waiting');
      expect(statusLabel(QueueStatus.loading), 'Loading');
      expect(statusLabel(QueueStatus.full), 'Full');
      expect(statusLabel(QueueStatus.unknown), 'Status not recognised');
    });
  });
}
