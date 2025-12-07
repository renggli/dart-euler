import 'dart:io';

import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_07.txt').readAsLinesSync();
final equations = input
    .map((line) => line.split(RegExp('[: ]+')).map(int.parse))
    .map((line) => (result: line.first, values: line.skip(1).toList()))
    .toList();

int add(int a, int b) => a + b;
int mul(int a, int b) => a * b;
int concat(int a, int b) {
  var base = 10;
  while (b >= base) {
    base *= 10;
  }
  return a * base + b;
}

bool test(int expected, List<int> values, List<int Function(int, int)> ops) {
  for (final operators in repeat(ops, count: values.length - 1).product()) {
    var actual = values.first;
    for (var o = 0; o < operators.length; o++) {
      actual = operators[o](actual, values[o + 1]);
    }
    if (actual == expected) return true;
  }
  return false;
}

int run(List<int Function(int, int)> ops) => equations
    .where((equation) => test(equation.result, equation.values, ops))
    .fold(0, (result, equation) => result + equation.result);

int part1() => run([add, mul]);

int part2() => run([add, mul, concat]);

void main() {
  assert(part1() == 28730327770375);
  assert(part2() == 424977609625985);
}
