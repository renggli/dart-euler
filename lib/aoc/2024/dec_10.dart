import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_10.txt').readAsStringSync();
final grid = Matrix.fromString(DataType.int8, input,
    columnSplitter: '',
    converter: (input) => input == '.' ? -1 : int.parse(input));
final starts = (0.to(grid.rowCount), 0.to(grid.colCount))
    .product()
    .map((pos) => Point(pos.first, pos.last))
    .where((point) => grid.getUnchecked(point.x, point.y) == 0)
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

int problem1() => starts.map((start) => countPaths([start], {})).sum();

int problem2() => starts.map((start) => countPaths([start])).sum();

void main() {
  assert(problem1() == 744);
  assert(problem2() == 1651);
}
