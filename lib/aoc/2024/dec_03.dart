import 'dart:io';

import 'package:data/data.dart';
import 'package:petitparser/petitparser.dart';

final input = File('lib/aoc/2024/dec_03.txt').readAsStringSync();

final number = digit().plusString().map(int.parse);
final mul = seq5(
  string('mul('),
  number,
  char(','),
  number,
  char(')'),
).map5((_, a, _, b, _) => (a, b));
final enable = string('do()').map((_) => true);
final disable = string('don\'t()').map((_) => false);

int part1() => mul.allMatches(input).map((pair) => pair.$1 * pair.$2).sum();

int part2() => (mul | enable | disable).allMatches(input).fold(
  (true, 0),
  (state, result) => switch (result) {
    (final int a, final int b) when state.$1 => (true, state.$2 + a * b),
    true => (true, state.$2),
    false => (false, state.$2),
    _ => state,
  },
).$2;

void main() {
  assert(part1() == 167650499);
  assert(part2() == 95846796);
}
