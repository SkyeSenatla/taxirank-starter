import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/core/fakes/rank_server.dart';

import '../support/harness.dart';

void main() {
  testWidgets('departures render server order, SAST, and exact takings', (
    tester,
  ) async {
    await pumpTaxiRank(tester, deepLink: '/departures');
    expect(find.text('GP 640-221'), findsOneWidget);
    expect(find.textContaining('08:42'), findsOneWidget);
    expect(find.textContaining('15 passengers'), findsWidgets);
    expect(find.textContaining('277,50'), findsOneWidget);
  });

  testWidgets('empty departures has a helpful message', (tester) async {
    await pumpTaxiRank(
      tester,
      deepLink: '/departures',
      server: RankServer(latency: Duration.zero, departures: []),
    );
    expect(find.text('No departures yet today.'), findsOneWidget);
  });

  testWidgets('failure has words, reference and a retry action', (
    tester,
  ) async {
    await pumpTaxiRank(
      tester,
      deepLink: '/departures',
      server: RankServer(latency: Duration.zero, departuresDown: true),
    );
    expect(find.text("We couldn't load today's departures."), findsOneWidget);
    expect(find.textContaining('Reference:'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('departure refreshes list without a restart', (
    tester,
  ) async {
    await pumpTaxiRank(tester, deepLink: '/queues/soweto');
    await tester.tap(find.text('Depart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Departures'));
    await tester.pumpAndSettle();
    expect(find.text('GP 412-871'), findsOneWidget);
  });
}
