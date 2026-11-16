/// When Riverpod may retry a provider that failed. main() and the test
/// harness both use this function, so keep its name.
///
/// Today: every failure, three times, 200, 400 and 800 ms apart.
Duration? appRetryPolicy(int retryCount, Object error) {
  if (retryCount >= 3) return null;
  return Duration(milliseconds: 200 * (1 << retryCount));
}
