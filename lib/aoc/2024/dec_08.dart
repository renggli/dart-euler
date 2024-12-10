import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_08.txt').readAsStringSync();

final grid = Matrix.fromString(DataType.string, input, columnSplitter: '');
final groups = (0.to(grid.rowCount), 0.to(grid.colCount))
    .product()
    .map((pos) => Point(pos.first, pos.last))
    .where((point) => grid.getUnchecked(point.x, point.y) != '.')
    .groupListsBy((point) => grid.getUnchecked(point.x, point.y))
    .values;

int problem1() {
  final antinodes = <Point<int>>{};
  for (final group in groups) {
    for (final antennas in group.combinations(2)) {
      final delta = antennas[1] - antennas[0];
      antinodes.addAll([antennas[0] - delta, antennas[1] + delta]
          .where((point) => grid.isWithinBounds(point.x, point.y)));
    }
  }
  return antinodes.length;
}

int problem2() {
  final antinodes = <Point<int>>{};
  for (final group in groups) {
    for (final antennas in group.combinations(2)) {
      final delta = antennas.last - antennas.first;
      for (var antinode = antennas.first;
          grid.isWithinBounds(antinode.x, antinode.y);
          antinode -= delta) {
        antinodes.add(antinode);
      }
      for (var antinode = antennas.last;
          grid.isWithinBounds(antinode.x, antinode.y);
          antinode += delta) {
        antinodes.add(antinode);
      }
    }
  }
  return antinodes.length;
}

void main() {
  assert(problem1() == 291);
  assert(problem2() == 1015);
}
