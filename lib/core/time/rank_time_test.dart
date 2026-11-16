import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/core/time/rank_time.dart';

void main() {
  test('shows UTC+2', () {
    expect(formatRankTime(DateTime.utc(2026, 11, 17, 6, 42)), '08:42');
  });

  test('crosses midnight', () {
    expect(formatRankTime(DateTime.utc(2026, 11, 17, 23, 30)), '01:30');
  });
}