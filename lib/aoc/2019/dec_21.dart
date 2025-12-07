import 'dart:io';

import 'utils/inputs.dart';
import 'utils/machine.dart';
import 'utils/outputs.dart';

final file = File('lib/aoc/2019/dec_21.txt');

int part1() {
  final input = ListInput(
    ['NOT C T', 'NOT A J', 'AND D T', 'OR T J', 'WALK\n'].join('\n').codeUnits,
  );
  final output = ListOutput();
  Machine.fromFile(file, input: input, output: output).run();
  return output.list.last;
}

int part2() {
  final input = ListInput(
    [
      'NOT C T',
      'NOT A J',
      'AND H T',
      'OR T J',
      'NOT B T',
      'AND A T',
      'AND C T',
      'OR T J',
      'AND D J',
      'RUN\n',
    ].join('\n').codeUnits,
  );
  final output = ListOutput();
  Machine.fromFile(file, input: input, output: output).run();
  return output.list.last;
}

void main() {
  assert(part1() == 19349939);
  assert(part2() == 1142412777);
}
