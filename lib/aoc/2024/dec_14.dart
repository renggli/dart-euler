import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_14.txt').readAsLinesSync();
const xMax = 101, yMax = 103;

final digits = RegExp(r'[0-9-]+');
final values = input
    .map(
      (line) => digits
          .allMatches(line)
          .map((value) => int.parse(value[0]!))
          .window(2)
          .map((values) => Point(values.first, values.last))
          .toList(),
    )
    .toList();
final positions = values.map((values) => values.first).toList();
final velocities = values.map((values) => values.last).toList();

int part1() {
  const steps = 100;
  final points = positions.mapIndexed(
    (index, point) => Point(
      (point.x + steps * velocities[index].x) % xMax,
      (point.y + steps * velocities[index].y) % yMax,
    ),
  );
  return points
      .where((point) => point.x != xMax ~/ 2 && point.y != yMax ~/ 2)
      .map((point) => Point(2 * point.x ~/ xMax, 2 * point.y ~/ yMax))
      .toMultiset()
      .elementCounts
      .product();
}

int part2() {
  var step = 1;
  final points = [...positions];
  while (true) {
    for (var r = 0; r < points.length; r++) {
      points[r] = Point(
        (points[r].x + velocities[r].x) % xMax,
        (points[r].y + velocities[r].y) % yMax,
      );
    }
    if (points.toSet().length == points.length) return step;
    step++;
  }
}

void main() {
  assert(part1() == 231782040);
  assert(part2() == 6475);
}
