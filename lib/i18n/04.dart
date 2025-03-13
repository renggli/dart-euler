import 'dart:io';

import 'package:timezone/standalone.dart';

final regexp = RegExp(
  r'\w+:\s+(?<location>[^ ]+)\s+(?<month>\w{3}) '
  r'(?<day>\d{2}), (?<year>\d{4}), (?<hour>\d{2}):(?<minute>\d{2})',
);
final months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

DateTime parseDateTime(String input) {
  final parts = regexp.firstMatch(input);
  if (parts == null) throw StateError(input);
  final location = getLocation(parts.namedGroup('location')!);
  final dateTime = TZDateTime(
    location,
    int.parse(parts.namedGroup('year')!),
    1 + months.indexOf(parts.namedGroup('month')!),
    int.parse(parts.namedGroup('day')!),
    int.parse(parts.namedGroup('hour')!),
    int.parse(parts.namedGroup('minute')!),
  );
  return dateTime;
}

int run(String filename) {
  var duration = const Duration();
  for (final pair in File(filename).readAsStringSync().split('\n\n')) {
    final [departure, arrival] = pair.split('\n').map(parseDateTime).toList();
    duration += arrival.difference(departure);
  }
  return duration.inMinutes;
}

void main() async {
  await initializeTimeZone('data/latest_all.tzf');
  assert(run('lib/i18n/04-test.txt') == 3143);
  assert(run('lib/i18n/04-input.txt') == 16451);
}
