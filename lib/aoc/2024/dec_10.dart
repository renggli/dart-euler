import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';

final input = File('lib/aoc/2024/dec_10.txt').readAsStringSync();
final grid = Matrix.fromString(
  DataType.int8,
  input,
  columnSplitter: '',
  converter: (input) => input == '.' ? -1 : int.parse(input),
);
final starts = grid.rowMajor
    .where((cell) => cell.value == 0)
    .map((cell) => Point(cell.row, cell.col))
    .toList();

const directions = [Point(-1, 0), Point(1, 0), Point(0, -1), Point(0, 1)];

int countPaths(List<Point<int>> stack, [Set<Point<int>>? seen]) {
  final sourcePoint = stack.last;
  final sourceValue = grid.getUnchecked(sourcePoint.x, sourcePoint.y);
  if (sourceValue == 9) return seen == null || seen.add(sourcePoint) ? 1 : 0;
  var count = 0;
  for (final direction in directions) {
    final targetPoint = sourcePoint + direction;
    if (grid.isWithinBounds(targetPoint.x, targetPoint.y)) {
      final targetValue = grid.getUnchecked(targetPoint.x, targetPoint.y);
      if (sourceValue + 1 == targetValue) {
        stack.add(targetPoint);
        count += countPaths(stack, seen);
        stack.removeLast();
      }
    }
  }
  return count;
}

int part1() => starts.map((start) => countPaths([start], {})).sum();

int part2() => starts.map((start) => countPaths([start])).sum();

void main() {
  assert(part1() == 744);
  assert(part2() == 1651);
}
