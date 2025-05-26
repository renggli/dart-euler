import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_15.txt').readAsStringSync().split('\n\n');
final warehouse = input.first;
final moves = input.last
    .split('')
    .map((char) => moveChars[char])
    .whereType<Point<int>>()
    .toList();

const robotChar = '@';
const boxChar = 'O';
const boxOpenChar = '[';
const boxCloseChar = ']';
const wallChar = '#';
const floorChar = '.';
const moveChars = {
  '^': Point(-1, 0),
  'v': Point(1, 0),
  '<': Point(0, -1),
  '>': Point(0, 1),
};
const boxChars = [boxChar, boxOpenChar, boxCloseChar];

Point<int> findPoint(Matrix<String> grid, String char) => grid.rowMajor
    .singleWhere((cell) => cell.value == char)
    .also((cell) => Point(cell.row, cell.col));

/// Try to move `start` in the given `direction`, return the possibly updated
/// `start` position.
Point<int> tryMove(
  Matrix<String> grid,
  Point<int> start,
  Point<int> direction,
) {
  var currentMoves = {start};
  final allMoves = [currentMoves];
  final isUpDown = direction.x != 0;
  while (true) {
    final candidateMoves = currentMoves
        .map((point) => point + direction)
        .toList();
    // A wall in the candidates is obstructing us.
    if (candidateMoves.any(
      (point) => grid.getUnchecked(point.x, point.y) == wallChar,
    )) {
      return start;
    }
    // Everything in the candidates can be moved.
    if (candidateMoves.every(
      (point) => grid.getUnchecked(point.x, point.y) == floorChar,
    )) {
      for (final source in allMoves.reversed.flatten()) {
        final sourceObj = grid.getUnchecked(source.x, source.y);
        final target = source + direction;
        final targetObj = grid.getUnchecked(target.x, target.y);
        grid.setUnchecked(target.x, target.y, sourceObj);
        grid.setUnchecked(source.x, source.y, targetObj);
      }
      return start + direction;
    }
    // Compute the next move set.
    final nextMoves = <Point<int>>{};
    for (final point in candidateMoves) {
      final targetObject = grid.getUnchecked(point.x, point.y);
      if (isUpDown && targetObject == boxOpenChar) {
        nextMoves.add(point);
        nextMoves.add(point + const Point(0, 1));
      } else if (isUpDown && targetObject == boxCloseChar) {
        nextMoves.add(point);
        nextMoves.add(point - const Point(0, 1));
      } else if (boxChars.contains(targetObject)) {
        nextMoves.add(point);
      }
    }
    // Bookkeeping.
    currentMoves = nextMoves;
    allMoves.add(nextMoves);
  }
}

int gpsSum(Matrix<String> grid, String char) {
  var result = 0;
  for (var x = 0; x < grid.rowCount; x++) {
    for (var y = 0; y < grid.colCount; y++) {
      if (grid.getUnchecked(x, y) == char) {
        result += 100 * x + y;
      }
    }
  }
  return result;
}

void run(Matrix<String> grid) {
  var current = findPoint(grid, robotChar);
  for (final move in moves) {
    current = tryMove(grid, current, move);
  }
}

int problem1() {
  final grid = Matrix.fromString(
    DataType.string,
    warehouse,
    columnSplitter: '',
  );
  run(grid);
  return gpsSum(grid, boxChar);
}

int problem2() {
  final grid = Matrix.fromString(
    DataType.string,
    warehouse
        .replaceAll(wallChar, '$wallChar$wallChar')
        .replaceAll(floorChar, '$floorChar$floorChar')
        .replaceAll(boxChar, '$boxOpenChar$boxCloseChar')
        .replaceAll(robotChar, '$robotChar$floorChar'),
    columnSplitter: '',
  );
  run(grid);
  return gpsSum(grid, boxOpenChar);
}

void main() {
  assert(problem1() == 1487337);
  assert(problem2() == 1521952);
}
