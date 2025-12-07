import 'dart:io';

import 'package:more/more.dart';

final input = File('lib/aoc/2015/dec_01.txt').readAsLinesSync();

int part1() {
  var floor = 0;
  for (final char in input.first.toList()) {
    floor += char == '(' ? 1 : -1;
  }
  return floor;
}

int part2() {
  var floor = 0;
  final chars = input.first.toList();
  for (var i = 0; i < chars.length; i++) {
    floor += chars[i] == '(' ? 1 : -1;
    if (floor == -1) return i + 1;
  }
  return 0;
}

void main() {
  assert(part1() == 138);
  assert(part2() == 1771);
}
