import 'dart:io';
import 'dart:math';

import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_10.txt').readAsLinesSync();

const north = Point(-1, 0);
const south = Point(1, 0);
const west = Point(0, -1);
const east = Point(0, 1);

const symbols = {
  '|': [north, south],
  '-': [east, west],
  'L': [north, east],
  'J': [north, west],
  '7': [south, west],
  'F': [south, east],
  'S': [north, south, west, east],
};

List<Point<int>> getNeighbours(Point<int> point, {bool other = false}) {
  final offsets = symbols[data[point.x][point.y]] ?? [];
  return offsets
      .map((offset) => point + offset)
      .where((neighbour) =>
          neighbour.x.between(0, data.length - 1) &&
          neighbour.y.between(0, data[point.x].length - 1) &&
          (other || getNeighbours(neighbour, other: true).contains(point)))
      .toList();
}

final graph = () {
  final graph = Graph<Point<int>, void>.undirected();
  for (var x = 0; x < data.length; x++) {
    for (var y = 0; y < data[x].length; y++) {
      final source = Point(x, y);
      for (final target in getNeighbours(source)) {
        graph.addEdge(source, target);
      }
    }
  }
  return graph;
}();

final start = () {
  for (var x = 0; x < data.length; x++) {
    for (var y = 0; y < data[x].length; y++) {
      if (data[x][y] == 'S') return Point(x, y);
    }
  }
  throw StateError('Start point not found');
}();

int problem1() => graph
    .shortestPathAll(start, (target) => true)
    .map((path) => path.values.length)
    .max();

int problem2() {
  final cycle = graph
      .shortestPathAll(start, (target) => true)
      .map((path) => path.target)
      .toSet();
  var area = 0;
  for (var x = 0; x < data.length; x++) {
    var windingNumber = 0;
    for (var y = 0; y < data[x].length; y++) {
      final point = Point(x, y);
      if (cycle.contains(point)) {
        if (getNeighbours(point).contains(point + south)) {
          windingNumber++;
        }
      } else if (windingNumber.isOdd) {
        area++; // we are inside
      }
    }
  }
  return area;
}

void main() {
  assert(problem1() == 6768);
  assert(problem2() == 351);
}
