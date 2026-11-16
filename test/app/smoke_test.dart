import 'package:flutter_test/flutter_test.dart';

import '../support/harness.dart';

void main() {
  testWidgets('the app opens on the Queues tab with every route', (
    tester,
  ) async {
    await pumpTaxiRank(tester);

    expect(find.text('Bree to Bara (Soweto)'), findsOneWidget);
    expect(find.text('Bree to Alexandra'), findsOneWidget);
    expect(find.text('Bree to Tembisa'), findsOneWidget);
    expect(find.text('Bree to Randburg'), findsOneWidget);
  });
}
