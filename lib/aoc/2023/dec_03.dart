import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_03.txt').readAsLinesSync().toList();

// Mapping from position-symbol to neighbouring numbers.
final neighbours = () {
  final result = ListMultimap<(int, int, {String char}), int>();
  for (var i = 0; i < data.length; i++) {
    final row = data[i];
    for (var j1 = 0; j1 < row.length;) {
      var j2 = j1;
      while (j2 < row.length && row[j2].startsWith(const CharMatcher.digit())) {
        j2++;
      }
      if (j1 == j2) {
        j1++;
      } else {
        for (var x = max(i - 1, 0); x < min(i + 2, data.length); x++) {
          for (var y = max(j1 - 1, 0); y < min(j2 + 1, row.length); y++) {
            final char = data[x][y];
            if (char != '.' &&
                char.startsWith(const CharMatcher.punctuation())) {
              result.add((x, y, char: char), int.parse(row.substring(j1, j2)));
            }
          }
        }
        j1 += j2 - j1;
      }
    }
  }
  return result;
}();

void main() {
  assert(neighbours.values.sum() == 535235);
  assert(
    neighbours
            .asMap()
            .entries
            .where((entry) => entry.key.char == '*' && entry.values.length == 2)
            .map((entry) => entry.values.product())
            .sum() ==
        79844424,
  );
}
