import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';
import 'package:more/iterable.dart';

extension on String {
  int get priority {
    final char = codeUnitAt(0);
    if (const CharMatcher.lowerCaseLetter().match(char)) {
      return char - 'a'.codeUnitAt(0) + 1;
    } else if (const CharMatcher.upperCaseLetter().match(char)) {
      return char - 'A'.codeUnitAt(0) + 27;
    }
    throw ArgumentError.value(this, 'this', 'Invalid character');
  }
}

final input = File('lib/aoc2022/dec_03.txt').readAsLinesSync();

void main() {
  final solution1 = input
      .map((line) => [line.take(line.length ~/ 2), line.skip(line.length ~/ 2)]
          .map((compartment) => compartment.split('').toSet())
          .toList())
      .map((compartments) => compartments[0]
          .intersection(compartments[1])
          .map((each) => each.priority)
          .sum())
      .sum();
  assert(solution1 == 8185);

  final solution2 = input
      .map((line) => line.split('').toSet())
      .chunked(3)
      .map((group) => group
          .reduce((a, b) => a.intersection(b))
          .map((each) => each.priority)
          .sum())
      .sum();
  assert(solution2 == 2817);
}
