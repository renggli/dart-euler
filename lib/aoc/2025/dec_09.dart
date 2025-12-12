import 'dart:math';

import '../../utils.dart';

class AoC2025Day9 extends AoC {
  AoC2025Day9()
    : super(year: 2025, day: 9, part1: 4739623064, part2: 1654141440);

  List<Point<int>> parse(String input) => input
      .split('\n')
      .map((line) => line.split(',').map(int.parse).toList())
      .map((parts) => Point(parts.first, parts.last))
      .toList();

  (int, int) sorted(int a, int b) => a > b ? (b, a) : (a, b);

  @override
  int part1(String input) {
    final tiles = parse(input);
    var result = 0;
    for (var i = 0; i < tiles.length; i++) {
      for (var j = i + 1; j < tiles.length; j++) {
        final delta = tiles[j] - tiles[i];
        result = max(result, (delta.x.abs() + 1) * (delta.y.abs() + 1));
      }
    }
    return result;
  }

  @override
  int part2(String input) {
    final tiles = parse(input);
    var result = 0;
    for (var i = 0; i < tiles.length; i++) {
      for (var j = i + 1; j < tiles.length; j++) {
        final (rx1, rx2) = sorted(tiles[i].x, tiles[j].x);
        final (ry1, ry2) = sorted(tiles[i].y, tiles[j].y);
        var isInside = true;
        for (var k = 0; k < tiles.length; k++) {
          final l = (k + 1) % tiles.length;
          final (x1, x2) = sorted(tiles[k].x, tiles[l].x);
          final (y1, y2) = sorted(tiles[k].y, tiles[l].y);
          // assert(x1 == x2 || y1 == y2, 'Not horizontal or vertical line');
          if (rx1 < x2 && x1 < rx2 && ry1 < y2 && y1 < ry2) {
            isInside = false;
            break;
          }
        }
        if (isInside) {
          result = max(result, (rx2 - rx1 + 1) * (ry2 - ry1 + 1));
        }
      }
    }
    return result;
  }
}

void main() => MainRunner().runProblem(AoC2025Day9());
