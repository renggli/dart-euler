import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

const directions = [
  Point(-1, 0), // north
  Point(1, 0), // south
  Point(0, -1), // west
  Point(0, 1), // east
];

final matrix = File('lib/aoc/2023/dec_21.txt').readAsLinesSync().also(
  (rows) => Matrix.fromPackedRows(
    DataType.string,
    rows.length,
    rows[0].length,
    rows.expand((line) => line.split('')).toList(),
  ),
);
final start = matrix.rowMajor
    .singleWhere((cell) => cell.value == 'S')
    .also((cell) => Point(cell.row, cell.col));

int problem1() {
  var gardens = <Point<int>>{start};
  for (var i = 1; i <= 64; i++) {
    gardens =
        gardens
            .expand(
              (source) => directions
                  .map((offset) => source + offset)
                  .where(
                    (target) =>
                        matrix.isWithinBounds(target.x, target.y) &&
                        matrix.get(target.x, target.y) != '#',
                  ),
            )
            .toSet();
  }

  return gardens.length;
}

// Solved this part in Google Sheets originally, code below is a lame re-implementation:
// https://docs.google.com/spreadsheets/d/1J_tTLmUnRwrWvexU6MTLj4z3GGF7vlt2daqtcLcNDKA/edit#gid=0
int problem2() {
  const steps = 26501365;
  final width = matrix.rowCount, half = 1 + matrix.rowCount ~/ 2;

  // Assert on the pre-conditions that make this work.
  assert(matrix.rowCount == matrix.colCount);
  assert((steps + half) % width == 0);

  // Collect the points for the square polynomial.
  var gardens = <Point<int>>{start};
  final xs = <int>[], ys = <int>[];
  for (var i = 1; xs.length < 3; i++) {
    gardens =
        gardens
            .expand(
              (source) => directions
                  .map((offset) => source + offset)
                  .where(
                    (target) =>
                        matrix.get(target.x % width, target.y % width) != '#',
                  ),
            )
            .toSet();
    if ((i + half) % width == 0) {
      xs.add((i + half) ~/ width);
      ys.add(gardens.length);
    }
  }

  // Find the polynomial and evaluate it at the right point.
  return Polynomial<int>.lagrange(
    DataType.integer,
    xs: xs.toVector(),
    ys: ys.toVector(),
  ).evaluate((steps + half) ~/ width);
}

void main() {
  assert(problem1() == 3737);
  assert(problem2() == 625382480005896);
}
