import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart' show ListEquality;
import 'package:more/more.dart';

const exampleInput = '''
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2
''';
final puzzleInput = File('lib/aoc/2025/dec_12.txt').readAsStringSync();

int part1(String input) {
  final blocks = input.trim().split('\n\n');
  final presents = blocks
      .take(blocks.length - 1)
      .map(Shape.parse)
      .map(Present.new)
      .toList();
  final regions = blocks.last.split('\n').map(Region.parse).toList();
  return regions.count((region) => region.canFit(presents));
}

class Present {
  final List<Shape> variants;

  Present(Shape shape)
    : variants = iterate(
        shape,
        (s) => s.rotated,
      ).take(4).expand((s) => [s, s.flipped]).unique().toList();
}

class Shape {
  Shape(Iterable<Cell> input) : cells = input.toList(growable: false) {
    cells.sort((a, b) => a.y == b.y ? a.x.compareTo(b.x) : a.y.compareTo(b.y));
    final offset = Cell(
      cells.map((cell) => cell.x).min(),
      cells.map((cell) => cell.y).min(),
    );
    for (var i = 0; i < cells.length; i++) {
      cells[i] -= offset;
    }
  }

  factory Shape.parse(String input) {
    final lines = input.split('\n');
    final grid = lines.skip(1).map((line) => line.split('')).toList();
    final cells = <Cell>[];
    for (var y = 0; y < grid.length; y++) {
      for (var x = 0; x < grid[y].length; x++) {
        if (grid[y][x] == '#') {
          cells.add(Cell(x, y));
        }
      }
    }
    return Shape(cells);
  }

  final List<Cell> cells;

  Shape get rotated => Shape(cells.map((p) => Cell(-p.y, p.x)));

  Shape get flipped => Shape(cells.map((p) => Cell(-p.x, p.y)));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shape && cellsEquality.equals(cells, other.cells));

  @override
  int get hashCode => cellsEquality.hash(cells);

  static const cellsEquality = ListEquality<Cell>();
}

typedef Cell = Point<int>;

class Region {
  Region(this.width, this.height, this.counts);

  factory Region.parse(String line) {
    final parts = line.split(': ');
    final dims = parts[0].split('x');
    return Region(
      int.parse(dims[0]),
      int.parse(dims[1]),
      parts[1].split(' ').map(int.parse).toList(),
    );
  }

  final int width;
  final int height;
  final List<int> counts;

  bool canFit(List<Present> presents) {
    // Compute the size of all required presents?
    var shapeArea = 0;
    for (var i = 0; i < counts.length; i++) {
      shapeArea += presents[i].variants[0].cells.length * counts[i];
    }
    // Test if the region can fit the required area.
    final regionArea = width * height;
    if (regionArea < shapeArea) {
      return false;
    }
    // Attempt to place the shapes in the region.
    return solve(
      grid: List.generate(width, (_) => List.filled(height, false)),
      counts: List<int>.from(counts),
      presents: presents,
    );
  }

  bool solve({
    required List<List<bool>> grid,
    required List<int> counts,
    required List<Present> presents,
    int startX = 0,
    int startY = 0,
  }) {
    // Find first possible spot.
    var y = startY, x = startX;
    while (y < height) {
      if (x >= width) {
        x = 0;
        y++;
        continue;
      }
      if (!grid[x][y]) {
        break;
      }
      x++;
    }
    // If we have placed all pieces, we are done.
    if (y >= height) {
      return counts.every((count) => count == 0);
    }
    // Option 1: Place a piece here.
    for (var i = 0; i < counts.length; i++) {
      if (counts[i] > 0) {
        final present = presents[i];
        for (final shape in present.variants) {
          if (canPlace(grid, shape, x, y)) {
            counts[i]--;
            place(grid, shape, x, y, true);
            if (solve(
              grid: grid,
              counts: counts,
              presents: presents,
              startX: x + 1,
              startY: y,
            )) {
              return true;
            }
            place(grid, shape, x, y, false);
            counts[i]++;
          }
        }
      }
    }
    // Option 2: Skip one spot.
    return solve(
      grid: grid,
      counts: counts,
      presents: presents,
      startX: x + 1,
      startY: y,
    );
  }

  bool canPlace(List<List<bool>> grid, Shape shape, int x, int y) {
    for (final cell in shape.cells) {
      final px = x + cell.x, py = y + cell.y;
      if (px < 0 || width <= px || py < 0 || height <= py) return false;
      if (grid[px][py]) return false;
    }
    return true;
  }

  void place(List<List<bool>> grid, Shape shape, int x, int y, bool value) {
    for (final cell in shape.cells) {
      grid[x + cell.x][y + cell.y] = value;
    }
  }
}

void main() {
  assert(part1(exampleInput) == 2);
  assert(part1(puzzleInput) == 536);
}
