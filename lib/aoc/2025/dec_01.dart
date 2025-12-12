import '../../utils.dart';

class AoC2025Day1 extends AoC {
  AoC2025Day1()
    : super(
        year: 2025,
        day: 1,
        part1: 1195,
        part2: 6770,
        examples: [
          AoCExample(
            input: 'L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82',
            part1: 3,
            part2: 6,
          ),
        ],
      );

  Iterable<int> parse(String input) => input
      .split('\n')
      .map((line) => (line[0] == 'L' ? -1 : 1) * int.parse(line.substring(1)));

  @override
  int part1(String input) {
    var pos = 50;
    var count = 0;
    for (final offset in parse(input)) {
      pos = (pos + offset) % 100;
      if (pos == 0) count++;
    }
    return count;
  }

  @override
  int part2(String input) {
    var pos = 50;
    var count = 0;
    for (final offset in parse(input)) {
      final old = pos;
      pos += offset;
      count += offset > 0
          ? (pos / 100).floor() - (old / 100).floor()
          : (old / 100).ceil() - (pos / 100).ceil();
    }
    return count;
  }
}

void main() => MainRunner().runProblem(AoC2025Day1());
