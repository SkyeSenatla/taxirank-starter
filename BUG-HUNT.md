# Bug hunt

## 1 — Floating-point money
What breaks: repeated decimal arithmetic can introduce rounding errors in passenger fares and takings.
The fix: store money as integer cents and format it only for display; use the server's returned totals.

## 2 — Unknown enum value
What breaks: `byName` throws when the server adds a status such as `OffDuty`.
The fix: map known wire strings explicitly and map every other value to `QueueStatus.unknown`.

## 3 — Wildcard status switch
What breaks: a new status is silently presented as Waiting, misleading the marshal.
The fix: add an explicit unknown case and make the switch exhaustive without a wildcard.

## 4 — Shared mutable queue
What breaks: opening another route overwrites the first route's state; callers can also mutate public notifier properties.
The fix: use a family keyed by route id and keep the id as the immutable family argument.

## 5 — Failed load test
What breaks: the test doesn't guarantee that the failed state is rendered before checking, and a retry path may never be exercised.
The fix: pump the asynchronous state, assert the failure message and retry control, tap retry, then assert recovered data.

## 6 — Imperative taxi navigation
What breaks: a pushed widget isn't addressable by a cold deep link and its whole taxi object is coupled to the caller.
The fix: use a typed nested route containing routeId and taxiId; fetch the taxi from those ids.

## 7 — Literal status colours
What breaks: feature colours cannot adapt consistently to light and dark themes and status is conveyed by colour alone.
The fix: put status colours in a ThemeExtension and always show a text label.

## 8 — Weak CI analysis
What breaks: `flutter analyze` may not fail for infos, so configured Riverpod lint findings can pass CI.
The fix: run `dart analyze --fatal-infos` after generation and before tests.
