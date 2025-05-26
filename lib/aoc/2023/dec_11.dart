import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_11.txt').readAsLinesSync();
final verticalLength = data.length, horizontalLength = data[0].length;

final verticalGaps = IntegerRange(verticalLength)
    .where(
      (i) => IntegerRange(horizontalLength).every((j) => data[i][j] == '.'),
    )
    .toList();

final horizontalGaps = IntegerRange(horizontalLength)
    .where((j) => IntegerRange(verticalLength).every((i) => data[i][j] == '.'))
    .toList();

final galaxies = IntegerRange(verticalLength)
    .expand(
      (i) => IntegerRange(
        horizontalLength,
      ).where((j) => data[i][j] != '.').map((j) => Point(i, j)),
    )
    .toList();

int computeDistance(
  Point<int> source,
  Point<int> target, {
  required int factor,
}) {
  final x1 = min(source.x, target.x), y1 = min(source.y, target.y);
  final x2 = max(source.x, target.x), y2 = max(source.y, target.y);
  return (x2 - x1) +
      (y2 - y1) +
      (factor - 1) * verticalGaps.count((each) => each.between(x1, x2 - 1)) +
      (factor - 1) * horizontalGaps.count((each) => each.between(y1, y2 - 1));
}

int computeAllDistances({required int factor}) => galaxies
    .combinations(2)
    .map((each) => computeDistance(each.first, each.last, factor: factor))
    .sum();

int problem1() => computeAllDistances(factor: 2);

int problem2() => computeAllDistances(factor: 1000000);

void main() {
  assert(problem1() == 10228230);
  assert(problem2() == 447073334102);
}
