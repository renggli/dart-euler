import 'dart:io';
import 'dart:math';

import 'package:charset/charset.dart';
import 'package:more/math.dart';
import 'package:more/more.dart';

const replacements = {
  '║': '│',
  '╚': '└',
  '╝': '┘',
  '╗': '┐',
  '╔': '┌',
  '═': '─',
  '╞': '├',
  '╠': '├',
  '╡': '┤',
  '╤': '┬',
  '╥': '┬',
  '╦': '┬',
  '╧': '┴',
  '╩': '┴',
  '╪': '┼',
  '╫': '┼',
};

const rotations = {
  '─': '│',
  '│': '─',
  '┌': '┐',
  '┐': '┘',
  '└': '┌',
  '┘': '└',
  '├': '┬',
  '┤': '┴',
  '┬': '┤',
  '┴': '├',
  '┼': '┼',
};

const connections = {
  '─': [Point(0, -1), Point(0, 1)],
  '│': [Point(-1, 0), Point(1, 0)],
  '┌': [Point(0, 1), Point(1, 0)],
  '┐': [Point(1, 0), Point(0, -1)],
  '└': [Point(-1, 0), Point(0, 1)],
  '┘': [Point(-1, 0), Point(0, -1)],
  '├': [Point(-1, 0), Point(0, 1), Point(1, 0)],
  '┤': [Point(-1, 0), Point(1, 0), Point(0, -1)],
  '┬': [Point(0, 1), Point(1, 0), Point(0, -1)],
  '┴': [Point(-1, 0), Point(0, 1), Point(0, -1)],
  '┼': [Point(-1, 0), Point(0, 1), Point(1, 0), Point(0, -1)],
};

int solve(
  List<List<String>> grid,
  Set<Point<int>> seen,
  Point<int> target,
  Point<int> point,
) {
  if (point == target) return 0;
  if (!seen.add(point)) return 0;
  if (!point.x.between(0, grid.length - 1)) return -1;
  if (!point.y.between(0, grid[point.x].length - 1)) return -1;

  final originalRotation = grid[point.x][point.y];
  if (originalRotation == ' ') return 0;
  if (originalRotation == '│') {
    stdout.writeln('here');
  }

  var rotationCount = 0;
  var currentRotation = originalRotation;
  var bestSolve = -1, bestRotation = '';
  while (true) {
    final outgoing = connections[currentRotation]!
        .map((delta) => delta + point)
        .toList();

    var total = -1;
    for (final next in outgoing) {
      final result = solve(grid, seen, next, target);
      if (result < 0) {
        total = -1;
        break;
      }
      if (total == -1) total = 0;
      total += result;
    }
    if (total != -1) {
      if (bestSolve == -1 || total + rotationCount < bestSolve) {
        bestSolve = total + rotationCount;
        bestRotation = currentRotation;
      }
    }

    rotationCount++;
    currentRotation = rotations[currentRotation]!;
    grid[point.x][point.y] = currentRotation;
    if (currentRotation == originalRotation) break;
  }

  if (bestSolve == -1) {
    return -1;
  } else {
    grid[point.x][point.y] = bestRotation;
    return bestSolve;
  }
}

int run(
  String filename, {
  required Point<int> topLeft,
  required Point<int> bottomRight,
}) {
  // Corp and normalize grid.
  final grid = File(filename)
      .readAsLinesSync(encoding: cp437)
      .sublist(topLeft.x, bottomRight.x + 1)
      .map((line) => line.split('').sublist(topLeft.y, bottomRight.y + 1))
      .toList(growable: false);
  for (final line in grid) {
    for (var i = 0; i < line.length; i++) {
      if (rotations.containsKey(line[i])) continue;
      line[i] = replacements[line[i]] ?? ' ';
    }
  }

  stdout.writeln('');
  stdout.writeln('Before:');
  stdout.writeln(grid.map((line) => line.join()).join('\n'));

  final result = solve(grid, {topLeft}, bottomRight, const Point(0, 1));

  stdout.writeln('');
  stdout.writeln('After:');
  stdout.writeln(grid.map((line) => line.join()).join('\n'));

  return result;
}

void main() {
  stdout.writeln(
    run(
      'lib/i18n/puzzle_16_test.txt',
      topLeft: const Point(0, 0),
      bottomRight: const Point(7, 11),
    ),
  );
  stdout.writeln(
    run(
      'lib/i18n/puzzle_16_input.txt',
      topLeft: const Point(4, 7),
      bottomRight: const Point(19, 72),
    ),
  );
  assert(false, 'Add assertions for solved puzzle');
}
