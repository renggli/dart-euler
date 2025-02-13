import 'dart:io';
import 'dart:math';

import 'package:more/more.dart';

final values =
    File('lib/aoc/2020/dec_12.txt')
        .readAsLinesSync()
        .map((value) => (value[0], int.parse(value.substring(1))))
        .toList();

Point<int> rotate(Point<int> point, int degrees) {
  final radian = 2.0 * pi * degrees / 360;
  return Point(
    (point.x * cos(radian) - point.y * sin(radian)).round(),
    (point.x * sin(radian) + point.y * cos(radian)).round(),
  );
}

class State {
  const State(this.pos, this.dir);

  final Point<int> pos;
  final Point<int> dir;

  State update1((String, int) command) {
    switch (command.first) {
      case 'N':
        return State(Point(pos.x, pos.y + command.second), dir);
      case 'S':
        return State(Point(pos.x, pos.y - command.second), dir);
      case 'E':
        return State(Point(pos.x + command.second, pos.y), dir);
      case 'W':
        return State(Point(pos.x - command.second, pos.y), dir);
      case 'L':
        return State(pos, rotate(dir, command.second));
      case 'R':
        return State(pos, rotate(dir, -command.second));
      case 'F':
        return State(
          Point(pos.x + command.second * dir.x, pos.y + command.second * dir.y),
          dir,
        );
      default:
        throw StateError('Invalid command: $command');
    }
  }

  State update2((String, int) command) {
    switch (command.first) {
      case 'N':
        return State(pos, Point(dir.x, dir.y + command.second));
      case 'S':
        return State(pos, Point(dir.x, dir.y - command.second));
      case 'E':
        return State(pos, Point(dir.x + command.second, dir.y));
      case 'W':
        return State(pos, Point(dir.x - command.second, dir.y));
      case 'L':
        return State(pos, rotate(dir, command.second));
      case 'R':
        return State(pos, rotate(dir, -command.second));
      case 'F':
        return State(
          Point(pos.x + command.second * dir.x, pos.y + command.second * dir.y),
          dir,
        );
      default:
        throw StateError('Invalid command: $command');
    }
  }

  @override
  String toString() => 'Ship{position: $pos, direction: $dir}';
}

void main() {
  // Puzzle 1
  const start1 = State(Point(0, 0), Point(1, 0));
  final state1 = values.fold<State>(start1, (state, cmd) => state.update1(cmd));
  assert(state1.pos.x.abs() + state1.pos.y.abs() == 521);

  // Puzzle 2
  const start2 = State(Point(0, 0), Point(10, 1));
  final state2 = values.fold<State>(start2, (state, cmd) => state.update2(cmd));
  assert(state2.pos.x.abs() + state2.pos.y.abs() == 22848);
}
