import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

typedef Cord = ({int row, int col});

const dirs = <Cord>[
  (row: -1, col: 0),
  (row: 0, col: 1),
  (row: 1, col: 0),
  (row: 0, col: -1),
];

final input = File('lib/aoc/2024/dec_06.txt').readAsStringSync();
final matrix = Matrix.fromString(DataType.string, input, columnSplitter: '');
final start = (0.to(matrix.rowCount), 0.to(matrix.colCount))
    .product()
    .map((pos) => (row: pos.first, col: pos.last))
    .firstWhere((pos) => matrix.getUnchecked(pos.row, pos.col) == '^');

ListMultimap<Cord, int>? run({Cord obstacle = (row: -1, col: -1)}) {
  var pos = start;
  var dir = 0;
  final seen = ListMultimap<Cord, int>();
  while (matrix.isWithinBounds(pos.row, pos.col)) {
    if (matrix.getUnchecked(pos.row, pos.col) == '#' ||
        (pos.row == obstacle.row && pos.col == obstacle.col)) {
      pos = (row: pos.row - dirs[dir].row, col: pos.col - dirs[dir].col);
      dir = (dir + 1) % dirs.length;
    } else {
      if (seen.containsEntry(pos, dir)) return null; // looping
      seen.add(pos, dir);
    }
    pos = (row: pos.row + dirs[dir].row, col: pos.col + dirs[dir].col);
  }
  return seen;
}

int problem1() => run()!.keys.length;

int problem2() => run()!.keys.count((pos) => run(obstacle: pos) == null);

void main() {
  assert(problem1() == 5269);
  assert(problem2() == 1957);
}
