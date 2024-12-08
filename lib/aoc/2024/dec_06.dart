import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

const dirs = <Point<int>>[Point(-1, 0), Point(0, 1), Point(1, 0), Point(0, -1)];

final input = File('lib/aoc/2024/dec_06.txt').readAsStringSync();
final matrix = Matrix.fromString(DataType.string, input, columnSplitter: '');
final start = (0.to(matrix.rowCount), 0.to(matrix.colCount))
    .product()
    .map((pos) => Point(pos.first, pos.last))
    .firstWhere((point) => matrix.getUnchecked(point.x, point.y) == '^');

ListMultimap<Point<int>, int>? run(
    {Point<int> obstacle = const Point(-1, -1)}) {
  var point = start;
  var dir = 0;
  final seen = ListMultimap<Point<int>, int>();
  while (matrix.isWithinBounds(point.x, point.y)) {
    if (matrix.getUnchecked(point.x, point.y) == '#' || point == obstacle) {
      point -= dirs[dir];
      dir = (dir + 1) % dirs.length;
    } else {
      if (seen.containsEntry(point, dir)) return null; // looping
      seen.add(point, dir);
    }
    point += dirs[dir];
  }
  return seen;
}

int problem1() => run()!.keys.length;
int problem2() => run()!.keys.count((point) => run(obstacle: point) == null);

void main() {
  assert(problem1() == 5269);
  assert(problem2() == 1957);
}
