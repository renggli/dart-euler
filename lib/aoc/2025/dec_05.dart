import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:more/more.dart';

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

final input = File('lib/aoc/2025/dec_05.txt').readAsStringSync().split('\n\n');
final ranges = input.first
    .split('\n')
    .map((line) => line.split('-').map(int.parse))
    .map((r) => (lo: r.first, hi: r.last))
    .toList();
final ids = input.last.trim().split('\n').map(int.parse).toList();

int problem1() => ids.count((id) => ranges.any((range) => range.contains(id)));

int problem2() => ranges.merged().map((range) => range.length).sum;

void main() {
  assert(problem1() == 681);
  assert(problem2() == 348820208020395);
}
