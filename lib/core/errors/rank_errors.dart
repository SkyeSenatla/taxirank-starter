/// The rank server's answers that aren't data, as an API's error responses
/// would be. Each carries a reference the marshal can quote.
sealed class RankError implements Exception {
  const new(this.message, this.reference);

  /// What went wrong, in words a marshal can read.
  final String message;

  /// The request's reference, like an API's correlation id.
  final String reference;

  @override
  String toString() => '$message (reference $reference)';
}

/// 404: no such route or taxi, or a taxi that isn't on that route.
final class RankNotFound extends RankError {
  /// Creates the error.
  const new(super.message, super.reference);
}

/// 409: the request doesn't fit the taxi's status, such as boarding a
/// passenger on a taxi that isn't loading.
final class RankConflict extends RankError {
  /// Creates the error.
  const new(super.message, super.reference);
}

/// 503: the rank's network is down. Trying again later may work.
final class RankUnavailable extends RankError {
  /// Creates the error.
  const new(super.message, super.reference);
}
