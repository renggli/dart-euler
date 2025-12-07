import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:more/graph.dart';
import 'package:more/math.dart';

const directions = <Point<int>>[
  Point(-1, 0),
  Point(1, 0),
  Point(0, -1),
  Point(0, 1),
];

String getName(Point<int> position) {
  final char = input[position.x][position.y];
  if (char == 'S' || char == 'E') return char;
  return '(${position.x}, ${position.y})';
}

int getElevation(Point<int> position) {
  var char = input[position.x][position.y];
  if (char == 'S') char = 'a';
  if (char == 'E') char = 'z';
  return char.codeUnitAt(0) - 'a'.codeUnitAt(0);
}

final input = File('lib/aoc/2022/dec_12.txt').readAsLinesSync();
final graph = () {
  final graph = Graph<String, void>.directed();
  for (var x = 0; x < input.length; x++) {
    for (var y = 0; y < input[x].length; y++) {
      final source = Point(x, y);
      for (final direction in directions) {
        final target = source + direction;
        if (target.x.between(0, input.length - 1) &&
            target.y.between(0, input[x].length - 1)) {
          final difference = getElevation(target) - getElevation(source);
          if (difference <= 1) graph.addEdge(getName(source), getName(target));
        }
      }
    }
  }
  return graph;
}();

int part1() => graph.shortestPath('S', 'E')!.edges.length;

int part2() {
  final lengths = <int>[];
  for (var x = 0; x < input.length; x++) {
    for (var y = 0; y < input[x].length; y++) {
      final source = Point(x, y);
      if (getElevation(source) == 0) {
        final path = graph.shortestPath(getName(source), 'E');
        if (path != null) lengths.add(path.edges.length);
      }
    }
  }
  return lengths.min;
}

void main() {
  assert(part1() == 425);
  assert(part2() == 418);
}
