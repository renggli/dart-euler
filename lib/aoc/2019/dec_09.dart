import 'dart:io';

import 'utils/inputs.dart';
import 'utils/machine.dart';
import 'utils/outputs.dart';

final file = File('lib/aoc/2019/dec_09.txt');

Iterable<int> run(int value) {
  final input = ListInput([value]), output = ListOutput();
  Machine.fromFile(file, input: input, output: output).run();
  return output.list;
}

int part1() => run(1).single;

int part2() => run(2).single;

void main() {
  assert(part1() == 2377080455);
  assert(part2() == 74917);
}
