# Bug hunt

Eight short snippets, each with at least one bug from Week 10. For each, write
**what breaks, and for whom**, and **the fix**, in a line each.

## 1

```dart
final double fare = 18.50;
Text('R ${(fare * passengers).toStringAsFixed(2)}');
```

What breaks: Using double for money can introduce rounding errors, affecting fare totals shown to the marshal.

The fix: Use the Cents value type and formatRands(). Display server-provided totals instead of recalculating them.

## 2

```dart
enum QueueStatus { waiting, loading, full }

QueueStatus parse(String wire) => QueueStatus.values.byName(wire.toLowerCase());
```

What breaks: byName() throws because delayed is not a declared enum value. The route may fail to render for the marshal.

The fix: Add an unknown enum case and explicitly map the server's exact strings (Waiting, Loading, Full), returning unknown for anything else.

## 3

```dart
String label(QueueStatus s) => switch (s) {
  QueueStatus.loading => 'Loading',
  QueueStatus.full => 'Full',
  _ => 'Waiting',
};
```

What breaks: The wildcard maps unknown statuses to "Waiting", misleading the rank marshal.

The fix: Remove the wildcard and use an exhaustive switch that explicitly handles every QueueStatus value.

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

What breaks: A single shared provider allows one route's taxis to appear on another route's screen, misleading the marshal.

The fix: Use a Riverpod family keyed by routeId so each route has independent state and cannot overwrite another.

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

What breaks: The test bypasses the real app setup and only checks that "Try again" appears, not that retry works.

The fix: Use pumpTaxiRank() with a failing server, tap "Try again", and verify that the queue loads.

## 6

```dart
onTap: () => Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => TaxiScreen(taxi: taxi)),
),
```

What breaks: Navigator.push() requires an existing taxi object and does not provide a deep-linkable address for the taxi.

The fix: Use a typed GoRouter route with routeId and taxiId. Fetch taxi details using those IDs instead of passing
the entire taxi object.

## 7

```dart
CircleAvatar(
  backgroundColor: taxi.status == QueueStatus.loading
      ? const Color(0xFF2E7D32)
      : const Color(0xFF9E9E9E),
),
```

What breaks: Hardcoded status colours do not adapt to dark mode and may be inconsistent or inaccessible to marshals.

The fix: Use a ThemeExtension with light and dark status colours, and display each status in words.

## 8

```yaml
# .github/workflows/ci.yml, with riverpod_lint switched on in analysis_options.yaml
      - name: Analyze
        run: flutter analyze
```

What breaks: CI uses flutter analyze, which misses the configured Riverpod lint violations, allowing broken code to pass.

The fix: Use dart analyze --fatal-infos in CI and fix the reported Riverpod lint violations without suppressing them.
