import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';
import 'package:taxirank/features/queues/domain/taxi_action.dart';

void main() {
  group('QueueStatus wire mapping', () {
    test('server values must match their exact case', () {
      expect(QueueStatus.fromWire('Waiting'), QueueStatus.waiting);
      expect(QueueStatus.fromWire('Loading'), QueueStatus.loading);
      expect(QueueStatus.fromWire('Full'), QueueStatus.full);
      expect(QueueStatus.fromWire('loading'), QueueStatus.unknown);
      expect(QueueStatus.fromWire('OffDuty'), QueueStatus.unknown);
    });

    test('all statuses have readable labels', () {
      expect(QueueStatus.waiting.label, 'Waiting');
      expect(QueueStatus.loading.label, 'Loading');
      expect(QueueStatus.full.label, 'Full');
      expect(QueueStatus.unknown.label, 'Status not recognised');
    });
  });

  group('allowed marshal action: status and available seats', () {
    test('waiting with free seats -> none', () {
      expect(actionFor(QueueStatus.waiting, true), TaxiAction.none);
    });

    test('loading with free seat -> board', () {
      expect(actionFor(QueueStatus.loading, true), TaxiAction.board);
    });

    test('loading without free seats -> none', () {
      expect(actionFor(QueueStatus.loading, false), TaxiAction.none);
    });

    test('full -> depart', () {
      expect(actionFor(QueueStatus.full, false), TaxiAction.depart);
      expect(actionFor(QueueStatus.full, true), TaxiAction.depart);
    });

    test('unknown -> none', () {
      expect(actionFor(QueueStatus.unknown, true), TaxiAction.none);
      expect(actionFor(QueueStatus.unknown, false), TaxiAction.none);
    });
  });
}
