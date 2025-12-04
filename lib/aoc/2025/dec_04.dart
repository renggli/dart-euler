import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';

final input = File('lib/aoc/2025/dec_04.txt').readAsStringSync();
final grid = Matrix.fromString(DataType.string, input, columnSplitter: '');

const offsets = [
  Point(-1, -1),
  Point(-1, 0),
  Point(-1, 1),
  Point(0, -1),
  Point(0, 1),
  Point(1, -1),
  Point(1, 0),
  Point(1, 1),
];

List<Point<int>> findRemovable() {
  final result = <Point<int>>[];
  grid.forEach((r, c, value) {
    if (value == '@') {
      var neighbors = 0;
      for (final offset in offsets) {
        if (grid.isWithinBounds(r + offset.x, c + offset.y) &&
            grid.get(r + offset.x, c + offset.y) == '@') {
          neighbors++;
        }
      }
      if (neighbors < 4) result.add(Point(r, c));
    }
  });
  return result;
}

int problem1() => findRemovable().length;

int problem2() {
  var removed = 0;
  while (true) {
    final removable = findRemovable();
    if (removable.isEmpty) break;
    removed += removable.length;
    for (final point in removable) {
      grid.set(point.x, point.y, '.');
    }
  }
  return removed;
}

void main() {
  assert(problem1() == 1537);
  assert(problem2() == 8707);
}
