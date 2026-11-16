import 'package:flutter/material.dart';

/// Colours for taxi queue statuses, adapted to light and dark themes.
@immutable
class QueueStatusColors extends ThemeExtension<QueueStatusColors> {
  /// Creates the queue status colours.
  const QueueStatusColors({
    required this.waiting,
    required this.loading,
    required this.full,
    required this.unknown,
  });

  final Color waiting;
  final Color loading;
  final Color full;
  final Color unknown;

  @override
  QueueStatusColors copyWith({
    Color? waiting,
    Color? loading,
    Color? full,
    Color? unknown,
  }) {
    return QueueStatusColors(
      waiting: waiting ?? this.waiting,
      loading: loading ?? this.loading,
      full: full ?? this.full,
      unknown: unknown ?? this.unknown,
    );
  }

  @override
  QueueStatusColors lerp(
    covariant ThemeExtension<QueueStatusColors>? other,
    double t,
  ) {
    if (other is! QueueStatusColors) return this;

    return QueueStatusColors(
      waiting: Color.lerp(waiting, other.waiting, t)!,
      loading: Color.lerp(loading, other.loading, t)!,
      full: Color.lerp(full, other.full, t)!,
      unknown: Color.lerp(unknown, other.unknown, t)!,
    );
  }
}

/// TaxiRank's look: one seed colour, light and dark.
abstract final class AppTheme {
  /// Rank amber: the seed every colour role grows from.
  static const seed = Color(0xFFB26A00);

  /// The light theme.
  static ThemeData light() => _build(Brightness.light);

  /// The dark theme.
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: brightness,
      ),
      extensions: [
        QueueStatusColors(
          waiting: isDark ? const Color(0xFFB0BEC5) : const Color(0xFF546E7A),
          loading: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
          full: isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100),
          unknown: isDark ? const Color(0xFFEF9A9A) : const Color(0xFFB71C1C),
        ),
      ],
    );
  }
}
