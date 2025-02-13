import 'dart:io';

import 'package:more/more.dart';

final reports =
    File('lib/aoc/2024/dec_02.txt')
        .readAsLinesSync()
        .map((line) => line.split(' ').map(int.parse).toList())
        .toList();

bool isSafe(List<int> report) {
  final (:min, :max) =
      report.pairwise().map((pair) => pair.first - pair.second).minMax();
  return (-3 <= min && max <= -1) || (1 <= min && max <= 3);
}

int problem1() => reports.count(isSafe);

int problem2() => reports.count(
  (report) =>
      report.indices().any((index) => isSafe([...report]..removeAt(index))),
);

void main() {
  assert(problem1() == 220);
  assert(problem2() == 296);
}
