import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/app/theme/app_theme.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';

void main() {
  test('each theme has usable status tokens', () {
    final light = AppTheme.light();
    final dark = AppTheme.dark();
    final lightColors = light.extension<RankStatusColors>()!;
    final darkColors = dark.extension<RankStatusColors>()!;
    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
    for (final status in QueueStatus.values) {
      expect(lightColors.forStatus(status), isNot(darkColors.forStatus(status)));
    }
  });
}
