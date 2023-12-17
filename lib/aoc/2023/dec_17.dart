import 'dart:io';
import 'dart:math';

import 'package:more/more.dart';

final bocks = File('lib/aoc/2023/dec_17.txt')
    .readAsLinesSync()
    .map((line) => line.split('').map(int.parse).toList())
    .toList();
final stop = Point(bocks.length - 1, bocks[0].length - 1);

typedef State = ({
  Point<int> pos,
  Point<int> dir,
  int count,
});

int solve({
  required int minBlocks, // before turning left or right
  required int maxBlocks, // allowed to go in one direction
}) =>
    AStarSearchIterable<State>(
      startVertices: const [
        (pos: Point(0, 0), dir: Point(0, 1), count: 0),
        (pos: Point(0, 0), dir: Point(1, 0), count: 0),
      ],
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
      targetPredicate: (state) =>
          state.pos == stop && state.count.between(minBlocks, maxBlocks),
      edgeCost: (source, target) => bocks[target.pos.x][target.pos.y],
      costEstimate: (source) =>
          (stop.x - source.pos.x) + (stop.y - source.pos.y),
    ).first.cost.round();

int problem1() => solve(minBlocks: 0, maxBlocks: 3);

int problem2() => solve(minBlocks: 4, maxBlocks: 10);

void main() {
  assert(problem1() == 1246);
  assert(problem2() == 1389);
}
