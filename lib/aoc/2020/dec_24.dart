import 'dart:io';
import 'dart:math';

import 'package:more/more.dart';

final instructions = File('lib/aoc/2020/dec_24.txt').readAsLinesSync();

const offsets = <String, Point<int>>{
  'e': Point(2, 0),
  'se': Point(1, -1),
  'sw': Point(-1, -1),
  'w': Point(-2, 0),
  'nw': Point(-1, 1),
  'ne': Point(1, 1),
};

Set<Point<int>> initialize(Iterable<String> instructions) {
  final result = <Point<int>>{};
  for (var instruction in instructions) {
    var position = const Point<int>(0, 0);
    while (instruction.isNotEmpty) {
      final offset = offsets.entries.firstWhere(
        (entry) => instruction.startsWith(entry.key),
      );
      instruction = instruction.substring(offset.key.length);
      position += offset.value;
    }
    result.contains(position) ? result.remove(position) : result.add(position);
  }
  return result;
}

Set<Point<int>> flip(Set<Point<int>> flipped) {
  final adjacent = <Point<int>, int>{};
  for (final tile in flipped) {
    for (final offset in offsets.values) {
      final position = tile + offset;
      adjacent[position] = (adjacent[position] ?? 0) + 1;
    }
  }
  return adjacent.entries
      .where(
        (adjacent) =>
            (flipped.contains(adjacent.key) && adjacent.value.between(1, 2)) ||
            (!flipped.contains(adjacent.key) && adjacent.value == 2),
      )
      .map((adjacent) => adjacent.key)
      .toSet();
}

int problem1() => initialize(instructions).length;

int problem2() => 0
    .to(100)
    .fold<Set<Point<int>>>(initialize(instructions), (prev, i) => flip(prev))
    .length;

void main() {
  assert(problem1() == 312);
  assert(problem2() == 3733);
}
