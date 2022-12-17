import 'dart:io';

import 'package:more/more.dart';

final passports = File('lib/aoc/2020/dec_04.txt')
    .readAsStringSync()
    .split('\n\n')
    .map((line) => line
        .split(RegExp(r'\s+'))
        .map((pair) => pair.split(':'))
        .toMap(key: (list) => list[0], value: (list) => list[1]));

final validation = <String, bool Function(String data)>{
  // (Birth Year) - four digits; at least 1920 and at most 2002.
  'byr': (data) => int.parse(data).between(1920, 2002),
  // (Issue Year) - four digits; at least 2010 and at most 2020.
  'iyr': (data) => int.parse(data).between(2010, 2020),
  // (Expiration Year) - four digits; at least 2020 and at most 2030.
  'eyr': (data) => int.parse(data).between(2020, 2030),
  'hgt': (data) {
    // (Height) - a number followed by either cm or in:
    final match = RegExp(r'^(\d+)(cm|in)$').firstMatch(data);
    final number = int.parse(match?.group(1) ?? '0');
    switch (match?.group(2)) {
      // cm, the number must be at least 150 and at most 193.
      case 'cm':
        return number.between(150, 193);
      // in, the number must be at least 59 and at most 76.
      case 'in':
        return number.between(59, 76);
      default:
        return false;
    }
  },
  // (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  'hcl': (data) => RegExp(r'^#[0-9a-f]{6}$').hasMatch(data),
  // (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  'ecl': (data) => RegExp(r'^(amb|blu|brn|gry|grn|hzl|oth)$').hasMatch(data),
  // (Passport ID) - a nine-digit number, including leading zeroes.
  'pid': (data) => RegExp(r'^[0-9]{9}$').hasMatch(data),
};

void main() {
  var count = 0, valid = 0;
  for (final passport in passports) {
    final isPassport = validation.keys.every(passport.containsKey);
    if (isPassport) {
      count++;
      final isValid =
          validation.entries.every((each) => each.value(passport[each.key]!));
      if (isValid) {
        valid++;
      }
    }
  }
  assert(count == 230);
  assert(valid == 156);
}
