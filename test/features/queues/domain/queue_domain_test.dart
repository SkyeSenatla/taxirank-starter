import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/features/queues/domain/queue_action.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';

void main() {
  group('QueueStatus.fromWire', () {
    test('maps the exact server statuses', () {
      expect(QueueStatus.fromWire('Waiting'), QueueStatus.waiting);
      expect(QueueStatus.fromWire('Loading'), QueueStatus.loading);
      expect(QueueStatus.fromWire('Full'), QueueStatus.full);
    });

    test('maps unexpected statuses to unknown', () {
      expect(QueueStatus.fromWire('Delayed'), QueueStatus.unknown);
      expect(QueueStatus.fromWire('loading'), QueueStatus.unknown);
      expect(QueueStatus.fromWire(''), QueueStatus.unknown);
    });

    test('provides a label for every status', () {
      expect(QueueStatus.waiting.label, 'Waiting');
      expect(QueueStatus.loading.label, 'Loading');
      expect(QueueStatus.full.label, 'Full');
      expect(QueueStatus.unknown.label, 'Status not recognised');
    });
  });

  group('allowedAction', () {
    test('allows boarding when loading with a free seat', () {
      expect(
        allowedAction(QueueStatus.loading, hasFreeSeat: true),
        QueueAction.board,
      );
    });

    test('disallows boarding when loading without a free seat', () {
      expect(
        allowedAction(QueueStatus.loading, hasFreeSeat: false),
        QueueAction.none,
      );
    });

    test('allows departure when full', () {
      expect(
        allowedAction(QueueStatus.full, hasFreeSeat: false),
        QueueAction.depart,
      );
      expect(
        allowedAction(QueueStatus.full, hasFreeSeat: true),
        QueueAction.depart,
      );
    });

    test('disallows actions for waiting taxis', () {
      expect(
        allowedAction(QueueStatus.waiting, hasFreeSeat: true),
        QueueAction.none,
      );
      expect(
        allowedAction(QueueStatus.waiting, hasFreeSeat: false),
        QueueAction.none,
      );
    });

    test('disallows actions for unknown statuses', () {
      expect(
        allowedAction(QueueStatus.unknown, hasFreeSeat: true),
        QueueAction.none,
      );
      expect(
        allowedAction(QueueStatus.unknown, hasFreeSeat: false),
        QueueAction.none,
      );
    });
  });
}
