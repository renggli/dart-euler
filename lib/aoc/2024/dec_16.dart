import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_16.txt').readAsStringSync();

final maze = Matrix.fromString(DataType.string, input, columnSplitter: '');
final start = maze.rowMajor
    .singleWhere((cell) => cell.value == 'S')
    .also((cell) => Point(cell.row, cell.col));
final end = maze.rowMajor
    .singleWhere((cell) => cell.value == 'E')
    .also((cell) => Point(cell.row, cell.col));

const directions = [Point(0, 1), Point(1, 0), Point(0, -1), Point(-1, 0)];
const costMove = 1;
const costRotate = 1000;

typedef State = ({Point<int> pos, int dir});

Iterable<Path<State, num>> search({bool includeAlternativePaths = false}) =>
    dijkstraSearch<State>(
      startVertices: [(pos: start, dir: 0)],
      targetPredicate: (target) => target.pos == end,
      successorsOf: (source) sync* {
        if (maze.getUnchecked(source.pos.x, source.pos.y) == 'E') return;
        final target = source.pos + directions[source.dir];
        if (maze.getUnchecked(target.x, target.y) != '#') {
          yield (pos: target, dir: source.dir);
        }
        for (final dir in [1, 3]) {
          final dir1 = (source.dir + dir) % 4;
          final target1 = source.pos + directions[dir1];
          if (maze.getUnchecked(target1.x, target1.y) != '#') {
            yield (pos: source.pos, dir: dir1);
          }
        }
      },
      edgeCost:
          (source, target) => source.dir == target.dir ? costMove : costRotate,
      includeAlternativePaths: includeAlternativePaths,
    );

int problem1() => search().first.cost.toInt();

int problem2() =>
    search(
      includeAlternativePaths: true,
    ).flatMap((path) => path.vertices.map((state) => state.pos)).toSet().length;

void main() {
  assert(problem1() == 130536);
  assert(problem2() == 1024);
}
