import 'dart:io';

import 'package:more/collection.dart';
import 'package:timezone/standalone.dart';

final halifaxTimezone = getLocation('America/Halifax');
final santiagoTimezone = getLocation('America/Santiago');

int run(String filename) {
  var result = 0;
  final input = File(filename).readAsLinesSync().indexed(start: 1);
  for (final MapEntry(key: index, value: line) in input) {
    final parts = line.split('\t');
    final date = DateTime.parse(parts[0]);
    final offset = Duration(hours: int.parse(parts[0].substring(23, 26)));
    final halifaxOffset = Duration(
      milliseconds:
          halifaxTimezone.timeZone(date.millisecondsSinceEpoch).offset,
    );
    final santiagoOffset = Duration(
      milliseconds:
          santiagoTimezone.timeZone(date.millisecondsSinceEpoch).offset,
    );
    final tzDate =
        offset == halifaxOffset
            ? TZDateTime.parse(halifaxTimezone, parts[0])
            : offset == santiagoOffset
            ? TZDateTime.parse(santiagoTimezone, parts[0])
            : throw StateError('Invalid input: ${parts[0]}');
    final corrected = tzDate
        .add(-Duration(minutes: int.parse(parts[2])))
        .add(Duration(minutes: int.parse(parts[1])));
    result += index * corrected.hour;
  }
  return result;
}

void main() async {
  await initializeTimeZone('data/latest_all.tzf');
  assert(run('lib/i18n/07-test.txt') == 866);
  assert(run('lib/i18n/07-input.txt') == 32152346);
}
