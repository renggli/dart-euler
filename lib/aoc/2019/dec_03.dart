import 'dart:io';
import 'dart:math';

final exampleInput = <String>['R8,U5,L5,D3', 'U7,R6,D4,L4'];
final puzzleInput = File('lib/aoc/2019/dec_03.txt').readAsLinesSync();

Map<(int, int), int> traceWire(String path) {
  final points = <(int, int), int>{};
  var x = 0;
  var y = 0;
  var step = 0;
  for (final move in path.split(',')) {
    final dir = move[0];
    final steps = int.parse(move.substring(1));
    final (dx, dy) = switch (dir) {
      'R' => (1, 0),
      'L' => (-1, 0),
      'U' => (0, 1),
      'D' => (0, -1),
      _ => throw ArgumentError('Unknown direction: $dir'),
    };
    for (var i = 0; i < steps; i++) {
      x += dx;
      y += dy;
      step++;
      points.putIfAbsent((x, y), () => step);
    }
  }
  return points;
}

int solve(
  List<String> data,
  int Function((int, int) point, int steps1, int steps2) score,
) {
  final wire1 = traceWire(data[0]);
  final wire2 = traceWire(data[1]);
  return wire1.entries
      .where((entry) => wire2.containsKey(entry.key))
      .map((entry) => score(entry.key, entry.value, wire2[entry.key]!))
      .reduce(min);
}

int part1(List<String> data) =>
    solve(data, (point, _, _) => point.$1.abs() + point.$2.abs());

int part2(List<String> data) =>
    solve(data, (_, steps1, steps2) => steps1 + steps2);

void main() {
  assert(part1(exampleInput) == 6);
  assert(part1(puzzleInput) == 1431);
  assert(part2(exampleInput) == 30);
  assert(part2(puzzleInput) == 48012);
}
