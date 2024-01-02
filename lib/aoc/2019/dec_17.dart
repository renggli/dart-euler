import 'dart:io';

import 'utils/inputs.dart';
import 'utils/machine.dart';
import 'utils/outputs.dart';

final file = File('lib/aoc/2019/dec_17.txt');

int problem1() {
  final output = StringOutput();
  Machine.fromFile(file, output: output).run();
  final data = output.buffer.toString().trim().split('\n');
  var result = 0;
  for (var x = 1; x < data.length - 1; x++) {
    for (var y = 1; y < data[x].length - 1; y++) {
      if (data[x][y] == '#' &&
          data[x - 1][y] == '#' &&
          data[x][y - 1] == '#' &&
          data[x + 1][y] == '#' &&
          data[x][y + 1] == '#') {
        result += x * y;
      }
    }
  }
  return result;
}

int problem2() {
  final output = ListOutput();
  final input = ListInput([
    // main movement routine:
    ...'A,A,B,C,B,C,B,C,B,A\n'.codeUnits,
    // movement function A, B and C:
    ...'R,6,L,12,R,6\n'.codeUnits,
    ...'L,12,R,6,L,8,L,12\n'.codeUnits,
    ...'R,12,L,10,L,10\n'.codeUnits,
    // continuous video feed:
    ...'n\n'.codeUnits,
  ]);
  final machine = Machine.fromFile(file, input: input, output: output);
  machine.memory[0] = 2;
  machine.run();
  return output.list.last;
}

void main() {
  assert(problem1() == 13580);
  assert(problem2() == 1063081);
}
