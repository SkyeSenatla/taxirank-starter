# Bug hunt

Eight short snippets, each with at least one bug from Week 10. For each, write
**what breaks, and for whom**, and **the fix**, in a line each.

## 1

```dart
final double fare = 18.50;
Text('R ${(fare * passengers).toStringAsFixed(2)}');
```

What breaks: The value is rounded off which will eventually create inconsistency when counting the money

The fix: Text('R ${(fare * passengers).toString()}');

## 2

```dart
enum QueueStatus { waiting, loading, full }

QueueStatus parse(String wire) => QueueStatus.values.byName(wire.toLowerCase());
```

What breaks: By the look of it the only argument we need is "String wire"  but in the return we use "values'

The fix: QueueStatus parse(String wire) => QueueStatus.wire.byName(wire.toLowerCase());

## 3

```dart
String label(QueueStatus s) => switch (s) {
  QueueStatus.loading => 'Loading',
  QueueStatus.full => 'Full',
  _ => 'Waiting',
};
```

What breaks:

The fix:

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

What breaks: taxi.status might not return same value as QueueStatus therefore the Color of CircleAvatar might always be false and will be  const Color(0xFF9E9E9E)

The fix: we need to make sure the values inside  taxi.status have same enum values

## 8

```yaml
# .github/workflows/ci.yml, with riverpod_lint switched on in analysis_options.yaml
      - name: Analyze
        run: flutter analyze
```

What breaks: flutter analyse is provided by flutter 

The fix: in pour situation we need to use riverpod_lint commands
