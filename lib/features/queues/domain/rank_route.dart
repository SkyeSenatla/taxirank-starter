import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taxirank/core/money/cents.dart';

part 'rank_route.freezed.dart';

/// One line of the routes list.
@freezed
abstract class RankRoute with _$RankRoute {
  /// Creates a route.
  const factory({
    required String id,
    required String name,
    required Cents fare,
    required int queueLength,
  }) = _RankRoute;
}
