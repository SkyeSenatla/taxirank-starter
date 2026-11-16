import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/app/theme/app_theme.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';

void main() {
  test('all four semantic status colours contrast with their surfaces', () {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      final surface = theme.colorScheme.surface;
      final colors = theme.extension<RankStatusColors>()!;
      for (final status in QueueStatus.values) {
        final foreground = colors.forStatus(status);
        final first = foreground.computeLuminance();
        final second = surface.computeLuminance();
        final lighter = first > second ? first : second;
        final darker = first > second ? second : first;
        final ratio = (lighter + 0.05) / (darker + 0.05);
        expect(ratio, greaterThanOrEqualTo(4.5), reason: status.label);
      }
    }
  });
}
