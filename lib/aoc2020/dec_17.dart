import 'dart:io';
import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:more/more.dart';

@immutable
class Cell {
  final int x, y, z, w;

  const Cell(this.x, this.y, [this.z = 0, this.w = 0]);

  Iterable<Cell> get neighbours sync* {
    const offsets = [-1, 0, 1];
    for (final ox in offsets) {
      for (final oy in offsets) {
        for (final oz in offsets) {
          for (final ow in offsets) {
            if (ox != 0 || oy != 0 || oz != 0 || ow != 0) {
              yield Cell(x + ox, y + oy, z + oz, w + ow);
            }
          }
        }
      }
    }
  }

  Cell min(Cell other) => Cell(math.min(x, other.x), math.min(y, other.y),
      math.min(z, other.z), math.min(w, other.w));

  Cell max(Cell other) => Cell(math.max(x, other.x), math.max(y, other.y),
      math.max(z, other.z), math.max(w, other.w));

  @override
  bool operator ==(Object other) =>
      other is Cell &&
      x == other.x &&
      y == other.y &&
      z == other.z &&
      w == other.w;

  @override
  int get hashCode => Object.hash(x, y, z, w);
}

final initialState = File('lib/aoc2020/dec_17.txt')
    .readAsLinesSync()
    .indexed()
    .flatMap((row) => row.value
        .split('')
        .indexed()
        .where((cell) => cell.value == '#')
        .map((cell) => Cell(row.index, cell.index)))
    .toSet();

Set<Cell> step(Set<Cell> active, bool is4d) {
  final result = <Cell>{};
  final min = active.reduce((a, b) => a.min(b));
  final max = active.reduce((a, b) => a.max(b));
  for (var x = min.x - 1; x <= max.x + 1; x++) {
    for (var y = min.y - 1; y <= max.y + 1; y++) {
      for (var z = min.z - 1; z <= max.z + 1; z++) {
        for (var w = min.w - 1; w <= max.w + 1; w++) {
          final point = Cell(x, y, z, is4d ? w : 0);
          final isActive = active.contains(point);
          final activeNeighbours = point.neighbours
              .where((neighbour) => active.contains(neighbour))
              .length;
          if ((isActive && activeNeighbours.between(2, 3)) ||
              (!isActive && activeNeighbours == 3)) {
            result.add(point);
          }
        }
      }
    }
  }
  return result;
}

int run(int count, bool is4D) {
  var current = initialState;
  for (var i = 0; i < count; i++) {
    current = step(current, is4D);
  }
  return current.length;
}

void main() {
  assert(run(6, false) == 333);
  assert(run(6, true) == 2676);
}
