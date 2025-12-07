import 'dart:io';

import 'package:more/collection.dart';

import 'utils/inputs.dart';
import 'utils/machine.dart';
import 'utils/outputs.dart';

final file = File('lib/aoc/2019/dec_13.txt');

int part1() {
  final output = ListOutput();
  Machine.fromFile(file, output: output).run();
  return output.list.chunked(3).count((triple) => triple.last == 2);
}

class Game implements Input, Output {
  final List<int> buffer = [];

  int paddle = -1;
  int ball = -1;
  int score = -1;

  @override
  void put(int value) {
    buffer.add(value);
    if (buffer.length == 3) {
      if (buffer.first == -1) {
        score = buffer.last;
      } else if (buffer.last == 3) {
        paddle = buffer[0];
      } else if (buffer.last == 4) {
        ball = buffer[0];
      }
      buffer.clear();
    }
  }

  @override
  int get() => ball.compareTo(paddle);
}

int part2() {
  final state = Game();
  final machine = Machine.fromFile(file, input: state, output: state);
  machine.memory[0] = 2; // insert 2 quarters
  machine.run();
  return state.score;
}

void main() {
  assert(part1() == 291);
  assert(part2() == 14204);
}
