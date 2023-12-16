import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_16.txt').readAsLinesSync().also((rows) =>
    Matrix.fromPackedRows(DataType.string, rows.length, rows[0].length,
        rows.expand((line) => line.split('')).toList()));

typedef Beam = ({Point<int> pos, Point<int> dir});

int solve(Beam start) {
  final seen = <Beam>{};
  final energized = <Point<int>>{};
  final queue = Queue.of([start]);
  while (queue.isNotEmpty) {
    final beam = queue.removeFirst();
    final (:pos, :dir) = beam;
    if (data.isWithinBounds(pos.x, pos.y) && seen.add(beam)) {
      final type = data.get(pos.x, pos.y);
      if (type == '/') {
        final ref = Point(-dir.y, -dir.x);
        queue.add((pos: pos + ref, dir: ref));
      } else if (type == '\\') {
        final ref = Point(dir.y, dir.x);
        queue.add((pos: pos + ref, dir: ref));
      } else if (type == '|' && dir.y != 0) {
        for (final ref in const [Point(-1, 0), Point(1, 0)]) {
          queue.add((pos: pos + ref, dir: ref));
        }
      } else if (type == '-' && dir.x != 0) {
        for (final ref in const [Point(0, -1), Point(0, 1)]) {
          queue.add((pos: pos + ref, dir: ref));
        }
      } else {
        queue.add((pos: pos + dir, dir: dir));
      }
      energized.add(pos);
    }
  }
  return energized.length;
}

int problem1() => solve(const (pos: Point(0, 0), dir: Point(0, 1)));

int problem2() => [
      for (var x = 0; x < data.rowCount; x++)
        (pos: Point(x, 0), dir: const Point(0, 1)),
      for (var x = 0; x < data.rowCount; x++)
        (pos: Point(x, data.colCount - 1), dir: const Point(0, -1)),
      for (var y = 0; y < data.colCount; y++)
        (pos: Point(0, y), dir: const Point(1, 0)),
      for (var y = 0; y < data.colCount; y++)
        (pos: Point(data.rowCount - 1, y), dir: const Point(-1, 0)),
    ].map(solve).max();

void main() {
  assert(problem1() == 7392);
  assert(problem2() == 7665);
}
