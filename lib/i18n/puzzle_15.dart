import 'dart:io';

import 'package:more/more.dart';
import 'package:timezone/standalone.dart';

// Human readable date parsing.

const months = [
  'january',
  'february',
  'march',
  'april',
  'may',
  'june',
  'july',
  'august',
  'september',
  'october',
  'november',
  'december',
];

final dateRegexp = RegExp(r'^(?<day>\d{1,2}) (?<month>\w+) (?<year>\d{4})$');

TZDateTime parseDate(Location location, String input) {
  final result = dateRegexp.firstMatch(input)!;
  return TZDateTime(
    location,
    int.parse(result.namedGroup('year')!),
    1 + months.indexOf(result.namedGroup('month')!.toLowerCase()),
    int.parse(result.namedGroup('day')!),
  );
}

// Model of place and timezone.

class Place {
  factory Place.fromString(String input) {
    final parts = input.split('\t');
    final location = getLocation(parts[1]);
    return Place(
      parts[0],
      location,
      parts[2].split(';').map((date) => parseDate(location, date)).toList(),
    );
  }

  Place(this.name, this.location, this.holidays);

  bool isWorkday(TZDateTime datetime) {
    if (datetime.weekday == DateTime.saturday ||
        datetime.weekday == DateTime.sunday) {
      return false;
    }
    for (final holiday in holidays) {
      if (datetime.day == holiday.day &&
          datetime.month == holiday.month &&
          datetime.year == holiday.year) {
        return false;
      }
    }
    return true;
  }

  // If the customer support is available at this time.
  bool isSupportAvailable(TZDateTime datetime) =>
      isWorkday(datetime) &&
      (100 * datetime.hour + datetime.minute).between(830, 1659);

  // If the customer is eligible for support at this time.
  bool isCustomerEligible(TZDateTime datetime) => isWorkday(datetime);

  final String name;
  final Location location;
  final List<TZDateTime> holidays;

  // Only used for customers, counts overtime caused.
  int overtimeMinutes = 0;

  @override
  String toString() => [name, location, holidays, overtimeMinutes].join('\t');
}

int run(String filename) {
  final parts = File(filename).readAsStringSync().split('\n\n');
  final supports = parts[0].split('\n').map(Place.fromString).toList();
  final customers = parts[1].split('\n').map(Place.fromString).toList();

  final start = TZDateTime.utc(2022, 1, 1, 0, 0);
  final end = TZDateTime.utc(2022, 12, 31, 24, 0);
  for (
    var datetime = start;
    !datetime.isAfter(end);
    datetime = TZDateTime.utc(
      datetime.year,
      datetime.month,
      datetime.day,
      datetime.hour,
      datetime.minute + 1,
    )
  ) {
    final isSupportAvailable = supports.any(
      (support) => support.isSupportAvailable(
        TZDateTime.from(datetime, support.location),
      ),
    );
    if (isSupportAvailable) continue;
    for (final customer in customers) {
      if (customer.isCustomerEligible(
        TZDateTime.from(datetime, customer.location),
      )) {
        customer.overtimeMinutes++;
      }
    }
  }

  final (:min, :max) = customers.minMax(
    comparator: keyOf((customer) => customer.overtimeMinutes),
  );
  return max.overtimeMinutes - min.overtimeMinutes;
}

void main() async {
  await initializeTimeZone('data/latest_all.tzf');
  assert(run('lib/i18n/puzzle_15_test.txt') == 3030);
  assert(run('lib/i18n/puzzle_15_input.txt') == 38670);
}
