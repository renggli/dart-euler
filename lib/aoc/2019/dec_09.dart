import 'dart:io';

import 'utils/machine.dart';

final file = File('lib/aoc/2019/dec_09.txt');

int problem1() => Machine.fromFile(file, input: [1]).run().single;

int problem2() => Machine.fromFile(file, input: [2]).run().single;

void main() {
  assert(problem1() == 2377080455);
  assert(problem2() == 74917);
}
