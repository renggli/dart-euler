import 'dart:io';
import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/graph.dart';

import 'utils/inputs.dart';
import 'utils/machine.dart';
import 'utils/outputs.dart';

final file = File('lib/aoc/2019/dec_15.txt');

const directions = {
  1: Point(-1, 0), // north
  2: Point(1, 0), // south
  3: Point(0, -1), // west
  4: Point(0, 1), // east
};

enum Type {
  wall,
  seen,
  goal;
}

class Complete extends Error {}

class State implements Input, Output {
  State([this.start = const Point(0, 0)])
      : visited = {start: Type.seen},
        path = [start];

  final Point<int> start;
  late final Point<int> goal;
  final Map<Point<int>, Type> visited;
  final List<Point<int>> path;

  @override
  int get() {
    // Try the next direction we haven't tried yet.
    for (final MapEntry(key: command, value: offset) in directions.entries) {
      final next = path.last + offset;
      if (!visited.containsKey(next)) {
        path.add(next);
        return command;
      }
    }
    // We've done all directions, move back to the previous point.
    if (path.length > 1) {
      final current = path.removeLast();
      for (final MapEntry(key: command, value: offset) in directions.entries) {
        final next = current + offset;
        if (path.last == next) {
          return command;
        }
      }
      throw StateError('Should not happen');
    }
    // We've reached all possible states.
    throw Complete();
  }

  @override
  void put(int value) {
    final type = Type.values[value];
    visited[path.last] = type;
    if (type == Type.wall) {
      path.removeLast();
    } else if (type == Type.goal) {
      goal = path.last;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    final xRange = visited.keys.map((each) => each.x).minMax();
    final yRange = visited.keys.map((each) => each.y).minMax();
    for (var y = yRange.min; y <= yRange.max; y++) {
      for (var x = xRange.min; x <= yRange.max; x++) {
        switch (visited[Point(x, y)]) {
          case Type.wall:
            buffer.write('#');
          case Type.seen:
            buffer.write('.');
          case Type.goal:
            buffer.write('X');
          default:
            buffer.write(' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}

final state = () {
  final state = State();
  try {
    Machine.fromFile(file, input: state, output: state).run();
  } on Complete {
    return state;
  }
  throw StateError('Should not happen');
}();

int problem1() => DijkstraSearchIterable<Point<int>>(
        startVertices: [state.start],
        targetPredicate: (target) => target == state.goal,
        successorsOf: (source) => directions.values
            .map((offset) => source + offset)
            .where((target) => state.visited[target] != Type.wall))
    .first
    .values
    .length;

int problem2() => DijkstraSearchIterable<Point<int>>(
        startVertices: [state.goal],
        targetPredicate: (target) => true,
        successorsOf: (source) => directions.values
            .map((offset) => source + offset)
            .where((target) => state.visited[target] != Type.wall))
    .map((path) => path.values.length)
    .max();

void main() {
  assert(problem1() == 300);
  assert(problem2() == 312);
}
