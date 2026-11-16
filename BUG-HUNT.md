# Bug hunt

Eight short snippets, each with at least one bug from Week 10. For each, write
**what breaks, and for whom**, and **the fix**, in a line each.

## 1

```dart
final double fare = 18.50;
Text('R ${(fare * passengers).toStringAsFixed(2)}');
```

What breaks: A `double` fare and multiplication can round by a cent; passengers see an incorrect charge.

The fix: Store cents as integer `Cents` and format the server-supplied money with `formatRands`.

## 2

```dart
enum QueueStatus { waiting, loading, full }

QueueStatus parse(String wire) => QueueStatus.values.byName(wire.toLowerCase());
```

What breaks: An unknown wire status such as `OffDuty` throws and hides Alexandra's entire queue; lowercasing also breaks the exact contract.

The fix: Switch on exact `Waiting`, `Loading`, `Full` values and map everything else to an explicit unknown status.

## 3

```dart
String label(QueueStatus s) => switch (s) {
  QueueStatus.loading => 'Loading',
  QueueStatus.full => 'Full',
  _ => 'Waiting',
};
```

What breaks: The wildcard mislabels an unknown/off-duty taxi as waiting, misleading the marshal.

The fix: List every enum status explicitly and show `Status not recognised` for unknown.

## 4

```dart
@Riverpod(keepAlive: true)
class CurrentQueue extends _$CurrentQueue {
  @override
  Future<RouteQueue?> build() async => null;

  Future<void> open(String routeId) async =>
      state = AsyncData(await ref.read(repoProvider).fetchQueue(routeId));
}
```

What breaks: A singleton state shared across routes can briefly display Soweto taxis on Alexandra's screen.

The fix: Use a Riverpod family keyed by `routeId`; route-specific data must not share mutable state.

## 5

```dart
testWidgets('a failed load shows Try again', (tester) async {
  await tester.pumpWidget(ProviderScope(
    overrides: [repoProvider.overrideWithValue(FailsOnceRepo())],
    child: const MaterialApp(home: QueueScreen()),
  ));
  await tester.pumpAndSettle();
  expect(find.text('Try again'), findsOneWidget);
});
```

What breaks: This simplified widget test bypasses the real router, retries and app wiring, giving false confidence.

The fix: Use the provided `pumpTaxiRank` harness and check actual route URLs, failures and retries.

## 6

```dart
onTap: () => Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => TaxiScreen(taxi: taxi)),
),
```

What breaks: Passing a taxi object to a page cannot restore it after the app opens from a direct address.

The fix: Use typed `/queues/:routeId/taxis/:taxiId` navigation and fetch the taxi using only those IDs.

## 7

```dart
CircleAvatar(
  backgroundColor: taxi.status == QueueStatus.loading
      ? const Color(0xFF2E7D32)
      : const Color(0xFF9E9E9E),
),
```

What breaks: A feature-level colour does not adapt to dark mode and may have poor contrast.

The fix: Use light/dark semantic colours from a `ThemeExtension`, always paired with a status label.

## 8

```yaml
# .github/workflows/ci.yml, with riverpod_lint switched on in analysis_options.yaml
      - name: Analyze
        run: flutter analyze
```

What breaks: The CI analyzer command can miss the Riverpod plugin lint, so a broken lint may pass unnoticed.

The fix: Use `dart analyze --fatal-infos` in CI; repair rather than suppress diagnostics.
