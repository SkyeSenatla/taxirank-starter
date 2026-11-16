import 'package:taxirank/core/errors/rank_errors.dart';

/// Retry transient network errors, not a definitive 404 or a 409.
/// This function is also used by the unchanged test harness.
Duration? appRetryPolicy(int retryCount, Object error) {
  if (error is! RankUnavailable || retryCount >= 3) return null;
  return Duration(milliseconds: 200 * (1 << retryCount));
}
