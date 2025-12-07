import 'dart:io';

import 'utils/inputs.dart';
import 'utils/machine.dart';
import 'utils/outputs.dart';

final file = File('lib/aoc/2019/dec_05.txt');

Iterable<int> run(int value) {
  final input = ListInput([value]), output = ListOutput();
  Machine.fromFile(file, input: input, output: output).run();
  return output.list;
}

int part1() => run(1).last;

int part2() => run(5).single;

void main() {
  assert(part1() == 9025675);
  assert(part2() == 11981754);
}
