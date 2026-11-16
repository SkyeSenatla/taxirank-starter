import 'package:flutter/material.dart';

/// TaxiRank's look: one seed colour, light and dark.
abstract final class AppTheme {
  /// Rank amber: the seed every colour role grows from.
  static const seed = Color(0xFFB26A00);

  /// The light theme.
  static ThemeData light() => _build(Brightness.light);

  /// The dark theme.
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
  );
}
