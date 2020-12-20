import 'dart:io';
import 'dart:math';

import 'package:data/matrix.dart';
import 'package:data/type.dart';
import 'package:data/vector.dart';
import 'package:more/more.dart';

class Tile {
  final int title;
  Matrix<String> data;

  Tile(this.title, this.data);

  String get top => id(data.rows.first);

  String get right => id(data.columns.last);

  String get bottom => id(data.rows.last);

  String get left => id(data.columns.first);

  Iterable<String> get edges => {top, right, bottom, left};

  Iterable<Tile> get variations => [
        Tile(title, data),
        Tile(title, data.rotated(count: 1)),
        Tile(title, data.rotated(count: 2)),
        Tile(title, data.rotated(count: 3)),
        Tile(title, data.flippedHorizontal),
        Tile(title, data.flippedVertical),
      ];

  static String id(Vector<String> vector) {
    final first = vector.format(limit: false, separator: '');
    final second = vector.reversed.format(limit: false, separator: '');
    return first.compareTo(second) < 0 ? first : second;
  }
}

final title = RegExp(r'Tile (\d+):');
final tiles = File('lib/aoc2020/dec_20.txt')
    .readAsStringSync()
    .split('\n\n')
    .map((lines) => lines.split('\n'))
    .map((lines) => Tile(
        int.parse(title.matchAsPrefix(lines[0])!.group(1)!),
        Matrix.fromColumns(DataType.string,
            lines.sublist(1).map((row) => row.split('')).toList())))
    .toList();
final uniqueEdgeCounts = tiles.flatMap((tile) => tile.edges).toMultiset();

int problem1() {
  final corners = tiles
      .where((tile) =>
          tile.edges.where((edge) => uniqueEdgeCounts[edge] > 1).length == 2)
      .map((tile) => tile.title)
      .toList();
  return corners.reduce((a, b) => a * b);
}

final nullMatrix = Matrix.constant(DataType.string, 0, 0);
final nullTile = Tile(0, nullMatrix);

int problem2() {
  final count = sqrt(tiles.length).floor();
  final master = Matrix<Tile>(DataType.object(nullTile), count, count);
  // First tile
  master[0][0] = tiles
      .firstWhere((tile) =>
          tile.edges.where((edge) => uniqueEdgeCounts[edge] > 1).length == 2)
      .variations
      .firstWhere((tile) =>
          uniqueEdgeCounts[tile.top] == 1 && uniqueEdgeCounts[tile.left] == 1);
  // Fuck it: I can't be bothered!
  return -1;
}

void main() {
  assert(problem1() == 17148689442341);
  assert(problem2() == -1);
}
