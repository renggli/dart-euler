import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_08.txt').readAsStringSync();

final grid = Matrix.fromString(DataType.string, input, columnSplitter: '');
final groups = grid.rowMajor
    .where((cell) => cell.value != '.')
    .groupListsBy((cell) => cell.value)
    .values
    .map((cells) => cells.map((cell) => Point(cell.row, cell.col)));

int part1() {
  final antinodes = <Point<int>>{};
  for (final group in groups) {
    for (final antennas in group.combinations(2)) {
      final delta = antennas[1] - antennas[0];
      antinodes.addAll(
        [
          antennas[0] - delta,
          antennas[1] + delta,
        ].where((point) => grid.isWithinBounds(point.x, point.y)),
      );
    }
  }
  return antinodes.length;
}

int part2() {
  final antinodes = <Point<int>>{};
  for (final group in groups) {
    for (final antennas in group.combinations(2)) {
      final delta = antennas.last - antennas.first;
      for (
        var antinode = antennas.first;
        grid.isWithinBounds(antinode.x, antinode.y);
        antinode -= delta
      ) {
        antinodes.add(antinode);
      }
      for (
        var antinode = antennas.last;
        grid.isWithinBounds(antinode.x, antinode.y);
        antinode += delta
      ) {
        antinodes.add(antinode);
      }
    }
  }
  return antinodes.length;
}

void main() {
  assert(part1() == 291);
  assert(part2() == 1015);
}
