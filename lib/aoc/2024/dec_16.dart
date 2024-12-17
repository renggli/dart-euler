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

const directions = [
  Point(0, 1),
  Point(1, 0),
  Point(0, -1),
  Point(-1, 0),
];
const costMove = 1;
const costRotate = 1000;

typedef State = ({
  Point<int> pos,
  int dir,
});

Iterable<State> successorsOf(State source) sync* {
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
}

num edgeCost(State source, State target) =>
    source.dir == target.dir ? costMove : costRotate;

final startVertices = [(pos: start, dir: 0)];

bool targetPredicate(State target) => target.pos == end;

int problem1() => DijkstraSearch(successorsOf: successorsOf, edgeCost: edgeCost)
    .find(startVertices: startVertices, targetPredicate: targetPredicate)
    .first
    .cost
    .toInt();

int problem2() => DijkstraSearch(
        successorsOf: successorsOf,
        edgeCost: edgeCost,
        includeAlternativePaths: true)
    .find(startVertices: startVertices, targetPredicate: targetPredicate)
    .flatMap((path) => path.vertices.map((state) => state.pos))
    .toSet()
    .length;

void main() {
  assert(problem1() == 130536);
  assert(problem2() == 1024);
}
