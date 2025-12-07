import 'dart:io';

import 'package:more/more.dart';

final reports = File('lib/aoc/2024/dec_02.txt')
    .readAsLinesSync()
    .map((line) => line.split(' ').map(int.parse).toList())
    .toList();

bool isSafe(List<int> report) {
  final (:min, :max) = report
      .pairwise()
      .map((pair) => pair.first - pair.second)
      .minMax();
  return (-3 <= min && max <= -1) || (1 <= min && max <= 3);
}

int part1() => reports.count(isSafe);

int part2() => reports.count(
  (report) =>
      report.indices().any((index) => isSafe([...report]..removeAt(index))),
);

void main() {
  assert(part1() == 220);
  assert(part2() == 296);
}
