import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';

final input = File('lib/aoc/2024/dec_04.txt').readAsStringSync();
final grid = Matrix.fromString(DataType.string, input, columnSplitter: '');

int problem1() {
  const word = 'XMAS';
  const directions = [
    Point(-1, -1),
    Point(-1, 0),
    Point(-1, 1),
    Point(0, -1),
    Point(0, 1),
    Point(1, -1),
    Point(1, 0),
    Point(1, 1),
  ];

  var found = 0;
  for (final direction in directions) {
    for (var r = 0; r < grid.rowCount; r++) {
      for (var c = 0; c < grid.colCount; c++) {
        var point = Point(r, c);
        final letters = <String>[];
        for (var l = 0; l < word.length; l++) {
          if (!grid.isWithinBounds(point.x, point.y)) break;
          letters.add(grid.getUnchecked(point.x, point.y));
          point += direction;
        }
        if (letters.join() == word) {
          found++;
        }
      }
    }
  }
  return found;
}

int problem2() {
  const words = ['MAS', 'SAM'];
  const directions = [
    Point(-1, -1),
    Point(0, 0),
    Point(1, 1),
    Point(1, -1),
    Point(0, 0),
    Point(-1, 1),
  ];

  var found = 0;
  for (var r = 1; r < grid.rowCount - 1; r++) {
    for (var c = 1; c < grid.colCount - 1; c++) {
      final letters = <String>[];
      for (final direction in directions) {
        letters.add(grid.getUnchecked(r + direction.x, c + direction.y));
      }
      final word = letters.join();
      if (words.contains(word.substring(0, 3)) &&
          words.contains(word.substring(3, 6))) {
        found++;
      }
    }
  }
  return found;
}

void main() {
  assert(problem1() == 2603);
  assert(problem2() == 1965);
}
