import 'package:flutter/material.dart';
import 'package:taxirank/features/queues/domain/queue_status.dart';

/// Status colours belong to the theme, not feature widgets.
@immutable
final class RankStatusColors extends ThemeExtension<RankStatusColors> {
  /// Creates all four semantic status colours.
  const RankStatusColors({
    required this.waiting,
    required this.loading,
    required this.full,
    required this.unknown,
  });

  /// Waiting status colour.
  final Color waiting;

  /// Boarding status colour.
  final Color loading;

  /// Full taxi status colour.
  final Color full;

  /// Unknown server status colour.
  final Color unknown;

  /// Resolve the colour for every status explicitly.
  Color forStatus(QueueStatus status) => switch (status) {
    QueueStatus.waiting => waiting,
    QueueStatus.loading => loading,
    QueueStatus.full => full,
    QueueStatus.unknown => unknown,
  };

  @override
  RankStatusColors copyWith({
    Color? waiting,
    Color? loading,
    Color? full,
    Color? unknown,
  }) => RankStatusColors(
    waiting: waiting ?? this.waiting,
    loading: loading ?? this.loading,
    full: full ?? this.full,
    unknown: unknown ?? this.unknown,
  );

  @override
  RankStatusColors lerp(ThemeExtension<RankStatusColors>? other, double t) {
    if (other is! RankStatusColors) return this;
    return RankStatusColors(
      waiting: Color.lerp(waiting, other.waiting, t)!,
      loading: Color.lerp(loading, other.loading, t)!,
      full: Color.lerp(full, other.full, t)!,
      unknown: Color.lerp(unknown, other.unknown, t)!,
    );
  }
}

/// TaxiRank's design tokens for light and dark appearances.
abstract final class AppTheme {
  /// Rank amber.
  static const seed = Color(0xFFB26A00);

  /// Light palette for status colours.
  static const lightStatus = RankStatusColors(
    waiting: Color(0xFF555D64),
    loading: Color(0xFF146C36),
    full: Color(0xFFAD4D00),
    unknown: Color(0xFF7F346C),
  );

  /// Dark palette for status colours.
  static const darkStatus = RankStatusColors(
    waiting: Color(0xFFB7C0C8),
    loading: Color(0xFF8BE4A6),
    full: Color(0xFFFFC28A),
    unknown: Color(0xFFFFA5E2),
  );

  /// Light mode.
  static ThemeData light() => _build(Brightness.light);

  /// Dark mode.
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
    extensions: [
      brightness == Brightness.light ? lightStatus : darkStatus,
    ],
  );
}
