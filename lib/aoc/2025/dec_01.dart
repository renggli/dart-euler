import 'package:more/more.dart';

import '../../tools.dart';

const example = 'L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82';

Iterable<int> parseInput(String input) => input
    .split('\n')
    .map((line) => (line[0] == 'L' ? -1 : 1) * int.parse(line.skip(1)));

@AoC(
  year: 2025,
  day: 1,
  part: 1,
  expected: 1195,
  examples: [Example(example, expected: 3)],
)
int part1(String input) {
  var pos = 50;
  var count = 0;
  for (final offset in parseInput(input)) {
    pos = (pos + offset) % 100;
    if (pos == 0) count++;
  }
  return count;
}

@AoC(
  year: 2025,
  day: 1,
  part: 2,
  expected: 6770,
  examples: [Example(example, expected: 6)],
)
int part2(String input) {
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

void main() => run();
