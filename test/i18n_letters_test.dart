import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _word = RegExp(r'[\p{L}\p{M}]+', unicode: true);
final _latin = RegExp(r'\p{Script=Latin}', unicode: true);
final _cyrillicOrGreek =
    RegExp(r'[\p{Script=Cyrillic}\p{Script=Greek}]', unicode: true);

void main() {
  test('no country name mixes Latin with Cyrillic or Greek letters', () {
    final bad = <String>[];
    final files = Directory('lib/src/i18n')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'));
    for (final file in files) {
      final names =
          Map<String, dynamic>.from(jsonDecode(file.readAsStringSync()));
      names.forEach((code, name) {
        for (final m in _word.allMatches('$name')) {
          final w = m.group(0)!;
          if (_latin.hasMatch(w) && _cyrillicOrGreek.hasMatch(w)) {
            bad.add('${file.uri.pathSegments.last} $code: $w');
          }
        }
      });
    }
    expect(bad, isEmpty);
  });
}
