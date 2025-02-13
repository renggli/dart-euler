import 'dart:io';

import 'utils/inputs.dart';
import 'utils/machine.dart';
import 'utils/outputs.dart';

final file = File('lib/aoc/2019/dec_25.txt');

int problem1() {
  final input = ListInput(
    [
      'south',
      'south',
      'west',
      'north',
      'north',
      'take tambourine',
      'south',
      'south',
      'east',
      'south',
      'take fixed point',
      'south',
      'west',
      'west',
      'south',
      'take easter egg',
      'north',
      'east',
      'east',
      'north',
      'north',
      'north',
      'west',
      'west',
      'west',
      'take space heater',
      'west',
      'west',
      '',
    ].join('\n').codeUnits,
  );
  final machine = Machine.fromFile(file, input: input);
  while (input.list.isNotEmpty) {
    machine.step();
  }
  final output = StringOutput();
  machine.output = output;
  machine.run();
  return RegExp(r'\d+')
      .allMatches(output.buffer.toString())
      .map((match) => int.parse(match.group(0)!))
      .single;
}

void main() {
  assert(problem1() == 2147485856);
}
