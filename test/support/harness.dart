import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxirank/app/app.dart';
import 'package:taxirank/app/retry_policy.dart';
import 'package:taxirank/core/fakes/rank_server.dart';
import 'package:taxirank/core/fakes/rank_server_provider.dart';

/// Pumps the whole app, as main() does, on a rank server with no delay
/// (or [server]). [deepLink] is the address the app starts at, as a link
/// would start it from cold. Don't change this file: your instructor's
/// checks use it too.
Future<void> pumpTaxiRank(
  WidgetTester tester, {
  RankServer? server,
  String? deepLink,
  Size size = const Size(400, 800),
  Brightness brightness = Brightness.light,
  double textScale = 1,
  bool settle = true,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  tester.platformDispatcher
    ..platformBrightnessTestValue = brightness
    ..textScaleFactorTestValue = textScale;
  if (deepLink != null) {
    tester.platformDispatcher.defaultRouteNameTestValue = deepLink;
  }
  addTearDown(tester.platformDispatcher.clearAllTestValues);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        rankServerProvider.overrideWithValue(
          server ?? RankServer(latency: Duration.zero),
        ),
      ],
      retry: appRetryPolicy,
      child: const TaxiRankApp(),
    ),
  );
  if (settle) await tester.pumpAndSettle();
}

/// The bottom bar's tab called [label].
Finder tab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));
