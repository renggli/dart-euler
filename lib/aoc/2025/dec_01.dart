import 'package:more/more.dart';

import '../../tools.dart';

Iterable<int> parseInput(List<String> input) =>
    input.map((line) => (line[0] == 'L' ? -1 : 1) * int.parse(line.skip(1)));

@AoC(year: 2025, day: 1, part: 1, expected: 1195)
int part1(List<String> input) {
  var pos = 50;
  var count = 0;
  for (final offset in parseInput(input)) {
    pos = (pos + offset) % 100;
    if (pos == 0) count++;
  }
  return count;
}

@AoC(year: 2025, day: 1, part: 2, expected: 6770)
int part2(List<String> input) {
  var pos = 50;
  var count = 0;
  for (final offset in parseInput(input)) {
    final old = pos;
    pos += offset;
    count += offset > 0
        ? (pos / 100).floor() - (old / 100).floor()
        : (old / 100).ceil() - (pos / 100).ceil();
  }
  return count;
}
