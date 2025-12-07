import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_20.txt').readAsStringSync();

final grid = Matrix.fromString(DataType.string, input, columnSplitter: '');
final end = grid.rowMajor
    .singleWhere((cell) => cell.value == 'E')
    .also((cell) => Point(cell.row, cell.col));

const directions = [Point(0, 1), Point(1, 0), Point(0, -1), Point(-1, 0)];
final pathLengths = dijkstraSearch(
  startVertices: [end],
  targetPredicate: (source) => true,
  successorsOf: (source) => directions
      .map((direction) => source + direction)
      .where((target) => grid.getUnchecked(target.x, target.y) != '#'),
).toMap(key: (path) => path.target, value: (path) => path.vertices.length - 1);

int run(int cheat) {
  var count = 0;
  for (var sx = 1; sx < grid.rowCount - 1; sx++) {
    for (var sy = 1; sy < grid.colCount - 1; sy++) {
      final start = Point(sx, sy);
      for (var ex = sx - cheat; ex <= sx + cheat; ex++) {
        for (var ey = sy - cheat; ey <= sy + cheat; ey++) {
          if (!ex.between(1, grid.rowCount - 1)) continue;
          if (!ey.between(1, grid.colCount - 1)) continue;
          final cost = (sx - ex).abs() + (sy - ey).abs();
          if (cost > cheat) continue;
          final lengthToStart = pathLengths[start];
          if (lengthToStart == null) continue;
          final end = Point(ex, ey);
          final lengthToEnd = pathLengths[end];
          if (lengthToEnd == null) continue;
          final saving = lengthToStart - lengthToEnd - cost;
          if (saving >= 100) count++;
        }
      }
    }
  }
  return count;
}

int part1() => run(2);

int part2() => run(20);

void main() {
  assert(part1() == 1454);
  assert(part2() == 997879);
}
