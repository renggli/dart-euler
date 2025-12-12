import 'dart:math';

import 'package:collection/collection.dart';

import '../../utils.dart';

typedef Range = ({int lo, int hi});

extension on Range {
  bool contains(int id) => lo <= id && id <= hi;
  int get length => hi - lo + 1;
}

extension on List<Range> {
  List<Range> merged() {
    final sorted = sortedBy((range) => range.lo);
    final merged = <Range>[sorted.first];
    for (var i = 1; i < sorted.length; i++) {
      final next = sorted[i];
      final current = merged.last;
      if (next.lo <= current.hi + 1) {
        merged.last = (lo: current.lo, hi: max(current.hi, next.hi));
      } else {
        merged.add(next);
      }
    }
    return merged;
  }
}

class AoC2025Day5 extends AoC {
  AoC2025Day5() : super(year: 2025, day: 5, part1: 681, part2: 348820208020395);

  ({List<Range> ranges, List<int> ids}) parse(String input) {
    final parts = input.split('\n\n');
    final ranges = parts.first
        .split('\n')
        .map((line) => line.split('-').map(int.parse))
        .map((r) => (lo: r.first, hi: r.last))
        .toList();
    final ids = parts.last.trim().split('\n').map(int.parse).toList();
    return (ranges: ranges, ids: ids);
  }

  @override
  int part1(String input) {
    final data = parse(input);
    return data.ids
        .where((id) => data.ranges.any((range) => range.contains(id)))
        .length;
  }

  @override
  int part2(String input) {
    final data = parse(input);
    return data.ranges
        .merged()
        .map((range) => range.length)
        .fold(0, (a, b) => a + b);
  }
}

void main() => MainRunner().runProblem(AoC2025Day5());
