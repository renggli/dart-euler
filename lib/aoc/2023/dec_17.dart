import 'dart:io';
import 'dart:math';

import 'package:more/more.dart';

final blocks = File('lib/aoc/2023/dec_17.txt')
    .readAsLinesSync()
    .map((line) => line.split('').map(int.parse).toList())
    .toList();
final stop = Point(blocks.length - 1, blocks[0].length - 1);

typedef State = ({
  Point<int> pos,
  Point<int> dir,
  int count,
});

Path<State, num> solve({
  required int minBlocks, // before turning left or right
  required int maxBlocks, // allowed to go in one direction
}) =>
    aStarSearch<State>(
      startVertices: const [
        (pos: Point(0, 0), dir: Point(0, 1), count: 0),
        (pos: Point(0, 0), dir: Point(1, 0), count: 0),
      ],
      targetPredicate: (state) =>
          state.pos == stop && state.count.between(minBlocks, maxBlocks),
      successorsOf: (state) {
        final left = Point(-state.dir.y, state.dir.x);
        final right = Point(state.dir.y, -state.dir.x);
        return [
          (pos: state.pos + state.dir, dir: state.dir, count: state.count + 1),
          if (minBlocks <= state.count)
            (pos: state.pos + left, dir: left, count: 1),
          if (minBlocks <= state.count)
            (pos: state.pos + right, dir: right, count: 1),
        ].where((state) =>
            state.pos.x.between(0, stop.x) &&
            state.pos.y.between(0, stop.y) &&
            state.count <= maxBlocks);
      },
      edgeCost: (source, target) => blocks[target.pos.x][target.pos.y],
      costEstimate: (source) =>
          (stop.x - source.pos.x) + (stop.y - source.pos.y),
    ).first;

Path<State, num> problem1() => solve(minBlocks: 0, maxBlocks: 3);

Path<State, num> problem2() => solve(minBlocks: 4, maxBlocks: 10);

// ignore: unreachable_from_main
void visualize() {
  const coloring = {
    false: {false: '\u001b[0m', true: '\u001b[106m'},
    true: {false: '\u001b[103m', true: '\u001b[102m'},
  };
  final path1 = problem1().vertices.map((state) => state.pos).toSet();
  final path2 = problem2().vertices.map((state) => state.pos).toSet();
  for (var x = 0; x <= stop.x; x++) {
    for (var y = 0; y <= stop.y; y++) {
      final point = Point(x, y);
      final color = coloring[path1.contains(point)]![path2.contains(point)]!;
      stdout.write('$color${blocks[x][y]} \u001b[0m');
    }
    stdout.writeln();
  }
}

void main() {
  assert(problem1().cost.round() == 1246);
  assert(problem2().cost.round() == 1389);
}
