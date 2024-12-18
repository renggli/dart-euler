import 'dart:io';
import 'dart:math';

import 'package:more/more.dart';

const size = 70;
const bytes = 1024;

final input = File('lib/aoc/2024/dec_18.txt').readAsLinesSync();

final coordinates = input
    .map((each) => each.split(',').map(int.parse))
    .map((each) => Point(each.first, each.last))
    .toList();

const directions = [
  Point(0, 1),
  Point(1, 0),
  Point(0, -1),
  Point(-1, 0),
];

Iterable<Path<Point<int>, num>> searchPath(int size,
        {Set<Point<int>> corrupt = const {}}) =>
    dijkstraSearch<Point<int>>(
        startVertices: const [Point(0, 0)],
        targetPredicate: (target) => target.x == size && target.y == size,
        successorsOf: (point) => directions.map((dir) => point + dir).where(
            (point) =>
                point.x.between(0, size) &&
                point.y.between(0, size) &&
                !corrupt.contains(point)));

int problem1() {
  final corrupt = coordinates.take(bytes).toSet();
  final visited = searchPath(size, corrupt: corrupt).first.vertices.toSet();
  return visited.length - 1;
}

String problem2() {
  final corrupt = <Point<int>>{};
  for (final point in coordinates) {
    corrupt.add(point);
    if (searchPath(size, corrupt: corrupt).isEmpty) {
      return '${point.x},${point.y}';
    }
  }
  throw AssertionError('No blocking point found');
}

void main() {
  assert(problem1() == 446);
  assert(problem2() == '39,40');
}
