import 'dart:io';

import 'package:more/collection.dart';

const formats = {
  'DMY': [31, 12, 99],
  'MDY': [12, 31, 99],
  'YMD': [99, 12, 31],
  'YDM': [99, 31, 12],
};
final nineEleven = DateTime(2001, 9, 11);

DateTime? createDate(String format, List<int> input) {
  final year = 2000 + input[format.indexOf('Y')];
  final month = input[format.indexOf('M')];
  final day = input[format.indexOf('D')];
  final result = DateTime(year, month, day);
  return result.year == year && result.month == month && result.day == day
      ? result
      : null;
}

String deriveFormat(List<List<int>> dates) {
  for (final MapEntry(key: name, value: format) in formats.entries) {
    if (dates.every((date) {
      for (var i = 0; i < 3; i++) {
        if (date[i] > format[i]) {
          return false;
        }
      }
      return createDate(name, date) != null;
    })) {
      return name;
    }
  }
  throw StateError('Unknown format for $dates');
}

String run(String filename) {
  final nameToDates = ListMultimap<String, List<int>>();
  for (final input in File(filename).readAsLinesSync()) {
    final parts = input.takeTo(': ').split('-').map(int.parse).toList();
    final names = input.skipTo(': ').split(', ').toList();
    for (final name in names) {
      nameToDates.add(name, parts);
    }
  }
  final names = <String>[];
  for (final name in nameToDates.keys) {
    final format = deriveFormat(nameToDates[name]);
    if (nameToDates[name].any(
      (date) => createDate(format, date) == nineEleven,
    )) {
      names.add(name);
    }
  }
  names.sort();
  return names.join(' ');
}

void main() {
  assert(run('lib/i18n/puzzle_09_test.txt') == 'Margot Peter');
  assert(
    run('lib/i18n/puzzle_09_input.txt') ==
        'Amelia Amoura Hugo Jack Jakob Junior Mateo',
  );
}
