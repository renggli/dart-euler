import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final matrix = File('lib/aoc/2023/dec_03.txt')
    .readAsLinesSync()
    .map((line) => line.toList())
    .toList();

int part1() {
  var sum = 0;
  for (var i = 0; i < matrix.length; i++) {
    final row = matrix[i];
    for (var j1 = 0; j1 < row.length;) {
      var j2 = j1;
      while (j2 < row.length && row[j2].startsWith(const CharMatcher.digit())) {
        j2++;
      }
      if (j1 == j2) {
        j1++;
      } else {
        neighbourSearch:
        for (var x = max(i - 1, 0); x < min(i + 2, matrix.length); x++) {
          for (var y = max(j1 - 1, 0); y < min(j2 + 1, row.length); y++) {
            if (matrix[x][y] != '.' &&
                matrix[x][y].startsWith(const CharMatcher.punctuation())) {
              sum += int.parse(row.sublist(j1, j2).join(''));
              break neighbourSearch;
            }
          }
        }
        j1 += j2 - j1;
      }
    }
  }
  return sum;
}

int part2() {
  final neighbours = ListMultimap<(int, int, String), int>();
  for (var i = 0; i < matrix.length; i++) {
    final row = matrix[i];
    for (var j1 = 0; j1 < row.length;) {
      var j2 = j1;
      while (j2 < row.length && row[j2].startsWith(const CharMatcher.digit())) {
        j2++;
      }
      if (j1 == j2) {
        j1++;
      } else {
        for (var x = max(i - 1, 0); x < min(i + 2, matrix.length); x++) {
          for (var y = max(j1 - 1, 0); y < min(j2 + 1, row.length); y++) {
            final char = matrix[x][y];
            if (char != '.' &&
                char.startsWith(const CharMatcher.punctuation())) {
              neighbours
                  .add((x, y, char), int.parse(row.sublist(j1, j2).join('')));
            }
          }
        }
        j1 += j2 - j1;
      }
    }
  }

  var sum = 0;
  for (var MapEntry(:key, :value) in neighbours.asMap().entries) {
    if (key.$3 == '*' && value.length == 2) {
      sum += value.product();
    }
  }
  return sum;
}

void main() {
  assert(part1() == 535235);
  assert(part2() == 79844424);
}
