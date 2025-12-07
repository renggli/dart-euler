import 'dart:io';

import 'package:data/data.dart';

final grid = File('lib/aoc/2025/dec_07.txt').readAsLinesSync();

int problem1() {
  var splits = 0;
  var beams = {grid[0].indexOf('S')};
  for (var row = 1; row < grid.length; row++) {
    final next = <int>{};
    for (final col in beams) {
      if (grid[row][col] == '^') {
        next.add(col - 1);
        next.add(col + 1);
        splits++;
      } else {
        next.add(col);
      }
    }
    beams = next;
  }
  return splits;
}

int problem2() {
  var particles = {grid[0].indexOf('S'): 1};
  for (var row = 1; row < grid.length; row++) {
    final next = <int, int>{};
    for (final MapEntry(key: col, value: count) in particles.entries) {
      if (grid[row][col] == '^') {
        next[col - 1] = (next[col - 1] ?? 0) + count;
        next[col + 1] = (next[col + 1] ?? 0) + count;
      } else {
        next[col] = (next[col] ?? 0) + count;
      }
    }
    particles = next;
  }
  return particles.values.sum();
}

void main() {
  assert(problem1() == 1598);
  assert(problem2() == 4509723641302);
}
