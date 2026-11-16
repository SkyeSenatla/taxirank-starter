# Bug hunt

Eight short snippets, each with at least one bug from Week 10. For each, write
**what breaks, and for whom**, and **the fix**, in a line each.

## 1

```dart
final double fare = 18.50;
Text('R ${(fare * passengers).toStringAsFixed(2)}');
```

What breaks: The total is claculated there which would be different to what the serverhas calculated.

The fix: Use the amount the server returns in integer cents and display it with fare cents.

## 2

```dart
enum QueueStatus { waiting, loading, full }

QueueStatus parse(String wire) => QueueStatus.values.byName(wire.toLowerCase());
```

What breaks: Making the case lower can allow for values outside the server to be accepted

The fix: Making the strings be like in the enum and setting other values to unknown.

## 3

```dart
String label(QueueStatus s) => switch (s) {
  QueueStatus.loading => 'Loading',
  QueueStatus.full => 'Full',
  _ => 'Waiting',
};
```

What breaks: An unknown status as is classified as Waiting.

The fix: Give every enum a switch for also a growing list

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

What breaks:

The fix:

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

What breaks:

The fix:

## 6

```dart
onTap: () => Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => TaxiScreen(taxi: taxi)),
),
```

What breaks:

The fix:

## 7

```dart
CircleAvatar(
  backgroundColor: taxi.status == QueueStatus.loading
      ? const Color(0xFF2E7D32)
      : const Color(0xFF9E9E9E),
),
```

What breaks:

The fix:

## 8

```yaml
# .github/workflows/ci.yml, with riverpod_lint switched on in analysis_options.yaml
      - name: Analyze
        run: flutter analyze
```

What breaks:

The fix:
