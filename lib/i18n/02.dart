import 'dart:io';

import 'package:more/more.dart';

String run(String filename) {
  final timestamps = Multiset<DateTime>();
  for (final line in File(filename).readAsLinesSync()) {
    timestamps.add(DateTime.parse(line));
  }
  for (final MapEntry(key: timestamp, value: count) in timestamps.entrySet) {
    if (count >= 4) {
      return timestamp.toUtc().toIso8601String().replaceFirst(
        '.000Z',
        '+00:00',
      );
    }
  }
  throw StateError('Not found');
}

void main() {
  assert(run('lib/i18n/02-test.txt') == '2019-06-05T12:15:00+00:00');
  assert(run('lib/i18n/02-input.txt') == '2020-10-25T01:30:00+00:00');
}
