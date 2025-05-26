import 'dart:io';

import 'package:data/data.dart';

final data = File(
  'lib/aoc/2019/dec_01.txt',
).readAsLinesSync().map(int.parse).toList();

int problem1() => data.map((each) => each ~/ 3 - 2).sum();

int problem2() => data.map((each) {
  var result = 0, last = each ~/ 3 - 2;
  while (last > 0) {
    result += last;
    last = last ~/ 3 - 2;
  }
  return result;
}).sum();

void main() {
  assert(problem1() == 3502510);
  assert(problem2() == 5250885);
}
