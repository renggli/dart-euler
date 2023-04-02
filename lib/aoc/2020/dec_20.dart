import 'dart:io';
import 'dart:math';

import 'package:data/matrix.dart';
import 'package:data/type.dart';
import 'package:data/vector.dart';
import 'package:more/more.dart';

// Warning: Ugly code ahead, solution inspired by others.
class Tile {
  Tile(this.title, this.data);

  final int title;
  Matrix<String> data;

  List<Tile> get variations => [
        Tile(title, data),
        Tile(title, data.flippedVertical),
        Tile(title, data.flippedHorizontal),
        Tile(title, data.rotated()),
        Tile(title, data.rotated().flippedVertical),
        Tile(title, data.rotated().flippedHorizontal),
        Tile(title, data.rotated(count: 2)),
        Tile(title, data.rotated(count: 3)),
      ];

  Tile get withoutEdges =>
      Tile(title, data.range(1, data.rowCount - 1, 1, data.colCount - 1));

  bool matchTop(Tile other) => data.rows.first.compare(other.data.rows.last);

  bool matchRight(Tile other) =>
      data.columns.last.compare(other.data.columns.first);

  bool matchBottom(Tile other) => data.rows.last.compare(other.data.rows.first);

  bool matchLeft(Tile other) =>
      data.columns.first.compare(other.data.columns.last);

  int count(Matrix<String> pattern) {
    var found = 0;
    for (var r = 0; r <= data.rowCount - pattern.rowCount; r++) {
      notFound:
      for (var c = 0; c <= data.colCount - pattern.colCount; c++) {
        for (var pr = 0; pr < pattern.rowCount; pr++) {
          for (var pc = 0; pc < pattern.colCount; pc++) {
            if (pattern.get(pr, pc) == '#' && data.get(r + pr, c + pc) != '#') {
              continue notFound;
            }
          }
        }
        found++;
      }
    }
    return found;
  }
}

final title = RegExp(r'Tile (\d+):');
final tiles = File('lib/aoc/2020/dec_20.txt')
    .readAsStringSync()
    .split('\n\n')
    .map((lines) => lines.split('\n'))
    .map((lines) => Tile(
        int.parse(title.matchAsPrefix(lines[0])!.group(1)!),
        Matrix.fromRows(DataType.string,
            lines.sublist(1).map((row) => row.split('')).toList())))
    .toList();
final monster = Matrix.fromRows(
    DataType.string,
    ['                  # ', '#    ##    ##    ###', ' #  #  #  #  #  #   ']
        .map((row) => row.split(''))
        .toList());

void main() {
  final unassigned = [...tiles];
  final root = unassigned.removeLast();
  final positions = <Point<int>, Tile>{const Point(0, 0): root};
  while (unassigned.isNotEmpty) {
    next:
    for (final tile in unassigned) {
      for (final variation in tile.variations) {
        for (final entry in positions.entries) {
          if (entry.value.matchTop(variation)) {
            positions[entry.key + const Point(0, -1)] = variation;
            unassigned.remove(tile);
            break next;
          } else if (entry.value.matchRight(variation)) {
            positions[entry.key + const Point(1, 0)] = variation;
            unassigned.remove(tile);
            break next;
          } else if (entry.value.matchBottom(variation)) {
            positions[entry.key + const Point(0, 1)] = variation;
            unassigned.remove(tile);
            break next;
          } else if (entry.value.matchLeft(variation)) {
            positions[entry.key + const Point(-1, 0)] = variation;
            unassigned.remove(tile);
            break next;
          }
        }
      }
    }
  }

  // Problem 1
  final minx = positions.keys.map((point) => point.x).min();
  final maxx = positions.keys.map((point) => point.x).max();
  final miny = positions.keys.map((point) => point.y).min();
  final maxy = positions.keys.map((point) => point.y).max();
  final problem1 = positions[Point(minx, miny)]!.title *
      positions[Point(maxx, miny)]!.title *
      positions[Point(minx, maxy)]!.title *
      positions[Point(maxx, maxy)]!.title;
  assert(problem1 == 17148689442341);

  // Problem 2
  final horizontals = <Matrix<String>>[];
  for (var x = minx; x <= maxx; x++) {
    final verticals = <Matrix<String>>[];
    for (var y = miny; y <= maxy; y++) {
      verticals.add(positions[Point(x, y)]!.withoutEdges.data);
    }
    horizontals.add(Matrix.concatVertical(DataType.string, verticals));
  }
  final master = Tile(
      666, Matrix.concatHorizontal(DataType.string, horizontals).toMatrix());
  int count(Matrix<String> data) =>
      data.columnMajor.where((each) => each == '#').length;
  final target = master.variations.max(
      comparator: naturalComparable<num>
          .onResultOf<Tile>((tile) => tile.count(monster)));
  assert(count(target.data) - target.count(monster) * count(monster) == 2009);
}
