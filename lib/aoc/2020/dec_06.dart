import 'dart:io';

import 'package:data/stats.dart';

final groups = File('lib/aoc/2020/dec_06.txt')
    .readAsStringSync()
    .split('\n\n')
    .map(
      (group) => group.split('\n').map((question) => {...question.split('')}),
    );

void main() {
  assert(
    groups
            .map(
              (group) =>
                  group.reduce((a, b) => a.union(b)).map((a) => a.length).sum(),
            )
            .sum() ==
        6565,
  );
  assert(
    groups
            .map(
              (group) => group
                  .reduce((a, b) => a.intersection(b))
                  .map((a) => a.length)
                  .sum(),
            )
            .sum() ==
        3137,
  );
}
