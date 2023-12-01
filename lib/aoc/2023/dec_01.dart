import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/char_matcher.dart';

List<int> extractDigits(String input, {Map<String, int> mapping = const {}}) {
  final result = <int>[];
  for (var i = 0; i < input.length; i++) {
    if (const CharMatcher.digit().everyOf(input[i])) {
      result.add(int.parse(input[i]));
    } else {
      for (final prefix in mapping.keys) {
        if (input.startsWith(prefix, i)) {
          result.add(mapping[prefix]!);
        }
      }
    }
  }
  return result;
}

final value1 = File('lib/aoc/2023/dec_01.txt')
    .readAsLinesSync()
    .map(extractDigits)
    .map((digits) => 10 * digits.first + digits.last)
    .sum();

final value2 = File('lib/aoc/2023/dec_01.txt')
    .readAsLinesSync()
    .map((line) => extractDigits(line, mapping: {
          'one': 1,
          'two': 2,
          'three': 3,
          'four': 4,
          'five': 5,
          'six': 6,
          'seven': 7,
          'eight': 8,
          'nine': 9,
        }))
    .map((digits) => 10 * digits.first + digits.last)
    .sum();

void main() {
  assert(value1 == 55834);
  assert(value2 == 53221);
}
