import 'dart:io';
import 'dart:math';

final input = File('lib/aoc/2025/dec_09.txt').readAsLinesSync();

final tiles = input
    .map((line) => line.split(',').map(int.parse).toList())
    .map((parts) => Point(parts.first, parts.last))
    .toList();

(int, int) sorted(int a, int b) => a > b ? (b, a) : (a, b);

int part1() {
  var result = 0;
  for (var i = 0; i < tiles.length; i++) {
    for (var j = i + 1; j < tiles.length; j++) {
      final delta = tiles[j] - tiles[i];
      result = max(result, (delta.x.abs() + 1) * (delta.y.abs() + 1));
    }
  }
  return result;
}

int part2() {
  var result = 0;
  for (var i = 0; i < tiles.length; i++) {
    for (var j = i + 1; j < tiles.length; j++) {
      final (x1, x2) = sorted(tiles[i].x, tiles[j].x);
      final (y1, y2) = sorted(tiles[i].y, tiles[j].y);
      var isInside = true;
      for (var k = 0; k < tiles.length; k++) {
        final l = (k + 1) % tiles.length;
        final (x3, x4) = sorted(tiles[k].x, tiles[l].x);
        final (y3, y4) = sorted(tiles[k].y, tiles[l].y);
        if (x1 < x4 && x2 > x3 && y1 < y4 && y2 > y3) {
          isInside = false;
          break;
        }
      }
      if (isInside) {
        result = max(result, (x2 - x1 + 1) * (y2 - y1 + 1));
      }
    }
  }
  return result;
}

void main() {
  assert(part1() == 4739623064);
  assert(part2() == 1654141440);
}
