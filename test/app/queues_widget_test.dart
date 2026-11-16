import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/core/fakes/rank_server.dart';

import '../support/harness.dart';

void main() {
  testWidgets('Soweto shows actions only where the domain permits', (
    tester,
  ) async {
    await pumpTaxiRank(tester, deepLink: '/queues/soweto');
    expect(find.text('Full'), findsWidgets);
    expect(find.text('Loading'), findsWidgets);
    expect(find.text('Waiting'), findsWidgets);
    expect(find.text('Board passenger'), findsOneWidget);
    expect(find.text('Depart'), findsOneWidget);
  });

  testWidgets('boarding one passenger charges one fare, not two', (
    tester,
  ) async {
    await pumpTaxiRank(tester, deepLink: '/queues/soweto');
    await tester.tap(find.text('Board passenger'));
    await tester.pumpAndSettle();
    expect(find.textContaining('13 of 15 seats'), findsOneWidget);
    expect(find.textContaining('240,50'), findsOneWidget);
  });

  testWidgets('Alexandra never paints a Soweto taxi even briefly', (
    tester,
  ) async {
    final server = RankServer(
      latency: Duration.zero,
      queueLatency: {'alex': const Duration(milliseconds: 150)},
    );
    await pumpTaxiRank(tester, server: server);
    await tester.tap(find.text('Bree to Bara (Soweto)'));
    await tester.pumpAndSettle();
    expect(find.text('GP 228-310'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bree to Alexandra'));
    await tester.pump();
    expect(find.text('GP 228-310'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('GP 117-406'), findsOneWidget);
    expect(find.text('Status not recognised'), findsOneWidget);
  });

  testWidgets('empty queue is described in words', (tester) async {
    await pumpTaxiRank(tester, deepLink: '/queues/randburg');
    expect(find.text('No taxis waiting on this route.'), findsOneWidget);
  });

  testWidgets('Tembisa shows a referenced failure, then succeeds on retry', (
    tester,
  ) async {
    await pumpTaxiRank(tester, deepLink: '/queues/tembisa');
    expect(find.text("We couldn't load this queue."), findsOneWidget);
    expect(find.textContaining('Reference:'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('GP 864-275'), findsOneWidget);
  });

  testWidgets('unknown route is not mistaken for a network problem', (
    tester,
  ) async {
    await pumpTaxiRank(tester, deepLink: '/queues/nowhere');
    expect(find.text('Route not found.'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('taxi detail direct link loads itself from two IDs', (
    tester,
  ) async {
    await pumpTaxiRank(
      tester,
      deepLink: '/queues/soweto/taxis/tx-102',
    );
    expect(find.text('GP 228-310'), findsOneWidget);
    expect(find.text('Position 2 in the queue'), findsOneWidget);
  });

  testWidgets('taxi on a different route produces a quick 404', (
    tester,
  ) async {
    await pumpTaxiRank(
      tester,
      server: RankServer(latency: Duration.zero),
      deepLink: '/queues/soweto/taxis/tx-201',
    );
    expect(find.text('Taxi not found.'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('tablet gets a navigation rail', (tester) async {
    await pumpTaxiRank(tester, size: const Size(900, 700));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
  testWidgets('tapping a taxi opens details, and changing tabs keeps them', (
    tester,
  ) async {
    await pumpTaxiRank(tester, deepLink: '/queues/soweto');
    await tester.tap(find.text('GP 228-310'));
    await tester.pumpAndSettle();
    expect(find.text('Position 2 in the queue'), findsOneWidget);
    await tester.tap(find.text('Departures'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Queues'));
    await tester.pumpAndSettle();
    expect(find.text('Position 2 in the queue'), findsOneWidget);
  });

}
