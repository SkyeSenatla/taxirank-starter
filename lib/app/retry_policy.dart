import 'package:taxirank/core/errors/rank_errors.dart';

/// When Riverpod may retry a provider that failed. main() and the test
/// harness both use this function, so keep its name.
Duration? appRetryPolicy(int retryCount, Object error) {
  if (error is! RankUnavailable || retryCount >= 3) return null;
  return Duration(milliseconds: 200 * (1 << retryCount));
}