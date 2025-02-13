import 'dart:io';

import 'package:data/stats.dart';

List<int> extractDigits(String input, Map<String, int> mapping) {
  final result = <int>[];
  for (var i = 0; i < input.length; i++) {
    for (final MapEntry(:key, :value) in mapping.entries) {
      if (input.startsWith(key, i)) {
        result.add(value);
      }
    }
  }
  return result;
}

const digitMapping = {
  '1': 1,
  '2': 2,
  '3': 3,
  '4': 4,
  '5': 5,
  '6': 6,
  '7': 7,
  '8': 8,
  '9': 9,
};

const digitAndWordMapping = {
  ...digitMapping,
  'one': 1,
  'two': 2,
  'three': 3,
  'four': 4,
  'five': 5,
  'six': 6,
  'seven': 7,
  'eight': 8,
  'nine': 9,
};

void main() {
  assert(
    File('lib/aoc/2023/dec_01.txt')
            .readAsLinesSync()
            .map((line) => extractDigits(line, digitMapping))
            .map((digits) => 10 * digits.first + digits.last)
            .sum() ==
        55834,
  );
  assert(
    File('lib/aoc/2023/dec_01.txt')
            .readAsLinesSync()
            .map((line) => extractDigits(line, digitAndWordMapping))
            .map((digits) => 10 * digits.first + digits.last)
            .sum() ==
        53221,
  );
}
