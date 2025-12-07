import 'dart:io';

import 'package:data/stats.dart';
import 'package:petitparser/petitparser.dart';

Parser<int> createParser(int problem) {
  final builder = ExpressionBuilder<int>();
  builder.primitive(digit().plus().flatten().trim().map(int.parse));
  builder.group().wrapper(
    char('(').trim(),
    char(')').trim(),
    (left, value, right) => value,
  );
  if (problem == 1) {
    // Addition and multiplication have same priority: Smalltalk :-)
    builder.group()
      ..left(char('+').trim(), (a, op, b) => a + b)
      ..left(char('*').trim(), (a, op, b) => a * b);
  } else if (problem == 2) {
    // Addition has higher priority than multiplication.
    builder.group().left(char('+').trim(), (a, op, b) => a + b);
    builder.group().left(char('*').trim(), (a, op, b) => a * b);
  }
  return builder.build().cast<int>().end();
}

final lines = File('lib/aoc/2020/dec_18.txt').readAsLinesSync();

int part1() =>
    lines.map(createParser(1).parse).map((result) => result.value).sum();

int part2() =>
    lines.map(createParser(2).parse).map((result) => result.value).sum();

void main() {
  assert(part1() == 4940631886147);
  assert(part2() == 283582817678281);
}
