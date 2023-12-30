import 'dart:io';

import 'package:more/interval.dart';

final intervals = File('lib/aoc/2022/dec_04.txt')
    .readAsLinesSync()
    .map((line) => line
        .split(',')
        .map((range) => range.split('-').map(int.parse).toList())
        .map((range) => Interval<num>(range[0], range[1]))
        .toList())
    .toList();

void main() {
  assert(intervals.where((group) {
        final intersection = group[0].intersection(group[1]);
        return group[0] == intersection || group[1] == intersection;
      }).length ==
      547);
  assert(intervals
          .where((group) => group[0].intersection(group[1]) != null)
          .length ==
      843);
}
