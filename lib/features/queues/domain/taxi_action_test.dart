import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';
import 'package:taxirank/features/queues/domain/taxi_action.dart';

void main() {
  // One test per row of the match.
  test('loading with a seat free: board', () {
    expect(actionFor(QueueStatus.loading, seatFree: true), TaxiAction.board);
  });
  test('loading with no seat free: nothing', () {
    expect(actionFor(QueueStatus.loading, seatFree: false), TaxiAction.none);
  });
  test('full: depart', () {
    expect(actionFor(QueueStatus.full, seatFree: false), TaxiAction.depart);
  });
  test('waiting: nothing', () {
    expect(actionFor(QueueStatus.waiting, seatFree: true), TaxiAction.none);
  });
  test('unknown: nothing', () {
    expect(actionFor(QueueStatus.unknown, seatFree: true), TaxiAction.none);
  });
}
