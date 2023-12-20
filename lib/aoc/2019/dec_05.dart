import 'dart:io';

import 'utils/machine.dart';

final file = File('lib/aoc/2019/dec_05.txt');

int problem1() => Machine.fromFile(file, input: [1]).run().last;

int problem2() => Machine.fromFile(file, input: [5]).run().single;

void main() {
  assert(problem1() == 9025675);
  assert(problem2() == 11981754);
}
