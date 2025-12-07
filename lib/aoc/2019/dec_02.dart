import 'dart:io';

import 'utils/machine.dart';

final file = File('lib/aoc/2019/dec_02.txt');

int part1() {
  final machine = Machine.fromFile(file);
  machine.memory[1] = 12;
  machine.memory[2] = 2;
  machine.run();
  return machine.memory[0];
}

int part2() {
  for (var noun = 0; noun < 100; noun++) {
    for (var verb = 0; verb < 100; verb++) {
      final machine = Machine.fromFile(file);
      machine.memory[1] = noun;
      machine.memory[2] = verb;
      machine.run();
      if (machine.memory[0] == 19690720) {
        return 100 * noun + verb;
      }
    }
  }
  throw StateError('Not found');
}

void main() {
  assert(part1() == 8017076);
  assert(part2() == 3146);
}
