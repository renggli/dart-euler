import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/iterable.dart';
import 'package:more/math.dart';

final instructions = File('lib/aoc/2022/dec_10.txt')
    .readAsLinesSync()
    .map((line) => line.split(' '));

List<int> run() {
  var value = 1;
  final cycles = <int>[];
  for (final instruction in instructions) {
    switch (instruction[0]) {
      case 'noop':
        cycles.add(value);
        break;
      case 'addx':
        cycles
          ..add(value)
          ..add(value);
        value += int.parse(instruction[1]);
        break;
      default:
        throw StateError('Invalid instruction: ${instruction[0]}');
    }
  }
  return cycles;
}

String render() {
  const width = 40;
  final buffer = StringBuffer();
  for (final each in run().indexed()) {
    final x = each.index % width;
    buffer.write(x.between(each.value - 1, each.value + 1) ? '#' : '.');
    if (x == width - 1) buffer.writeln();
  }
  return buffer.toString();
}

void main() {
  const interesting = {20, 60, 100, 140, 180, 220};
  assert(run()
          .indexed(offset: 1)
          .where((each) => interesting.contains(each.index))
          .map((each) => each.index * each.value)
          .sum() ==
      14360);

  // BGKAEREZ
  assert(render() ==
      "###...##..#..#..##..####.###..####.####.\n"
          "#..#.#..#.#.#..#..#.#....#..#.#.......#.\n"
          "###..#....##...#..#.###..#..#.###....#..\n"
          "#..#.#.##.#.#..####.#....###..#.....#...\n"
          "#..#.#..#.#.#..#..#.#....#.#..#....#....\n"
          "###...###.#..#.#..#.####.#..#.####.####.\n");
}
