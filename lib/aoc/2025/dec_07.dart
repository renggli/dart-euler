import 'package:data/data.dart';

import '../../utils.dart';

class AoC2025Day7 extends AoC {
  AoC2025Day7() : super(year: 2025, day: 7, part1: 1598, part2: 4509723641302);

  List<String> parse(String input) => input.trim().split('\n');

  @override
  int part1(String input) {
    final grid = parse(input);
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

  @override
  int part2(String input) {
    final grid = parse(input);
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
}

void main() => MainRunner().runProblem(AoC2025Day7());
