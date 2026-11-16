import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Two items from a reviewer's send-back list, checked by CI. Plain file
/// reads, no widgets.
void main() {
  List<File> dartFiles(String dir) =>
      Directory(dir)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .where((f) => !f.path.endsWith('.g.dart'))
          .where((f) => !f.path.endsWith('.freezed.dart'))
          .toList();

  String name(File f) => f.path.replaceAll(r'\', '/');

  test('no colour is typed into a feature: the theme decides colours', () {
    final offenders = [
      for (final file in dartFiles('lib/features'))
        if (file.readAsStringSync().contains('Color(0x')) name(file),
    ];

    expect(offenders, isEmpty, reason: 'Use a theme role or a status token');
  });

  test('no screen reaches past a provider to the data or the server', () {
    final screens = dartFiles('lib/features').where(
      (f) =>
          name(f).contains('/presentation/') &&
          name(f).endsWith('_screen.dart'),
    );
    final offenders = [
      for (final file in screens)
        if (file.readAsStringSync().contains('/data/') ||
            file.readAsStringSync().contains('core/fakes/'))
          name(file),
    ];

    expect(screens, isNotEmpty);
    expect(offenders, isEmpty, reason: 'Watch a provider instead');
  });
}
