import 'dart:io';

import 'package:collection/collection.dart';
import 'package:more/collection.dart';

final input = File('lib/aoc/2025/dec_03.txt')
    .readAsLinesSync()
    .map((line) => line.toList().map(int.parse).toList())
    .toList();

int solve(List<int> digits, int count) {
  var position = 0;
  var result = 0;
  for (var remaining = count; remaining >= 1; remaining--) {
    final searchEnd = digits.length - remaining;
    for (var digit = 9; digit >= 1; digit--) {
      final index = digits.indexOf(digit, position);
      if (index != -1 && index <= searchEnd) {
        result = result * 10 + digit;
        position = index + 1;
        break;
      }
    }
  }
  return result;
}

int problem1() => input.map((line) => solve(line, 2)).sum;

int problem2() => input.map((line) => solve(line, 12)).sum;

void main() {
  assert(problem1() == 17034);
  assert(problem2() == 168798209663590);
}
