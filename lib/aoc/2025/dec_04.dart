import 'dart:math';

import 'package:data/data.dart';

import '../../utils.dart';

class AoC2025Day4 extends AoC {
  AoC2025Day4() : super(year: 2025, day: 4, part1: 1537, part2: 8707);

  static const offsets = [
    Point(-1, -1),
    Point(-1, 0),
    Point(-1, 1),
    Point(0, -1),
    Point(0, 1),
    Point(1, -1),
    Point(1, 0),
    Point(1, 1),
  ];

  Matrix<String> parse(String input) =>
      Matrix.fromString(DataType.string, input, columnSplitter: '');

  List<Point<int>> findRemovable(Matrix<String> grid) {
    final result = <Point<int>>[];
    grid.forEach((r, c, value) {
      if (value == '@') {
        var neighbors = 0;
        for (final offset in offsets) {
          if (grid.isWithinBounds(r + offset.x, c + offset.y) &&
              grid.get(r + offset.x, c + offset.y) == '@') {
            neighbors++;
          }
        }
        if (neighbors < 4) result.add(Point(r, c));
      }
    });
    return result;
  }

  @override
  int part1(String input) => findRemovable(parse(input)).length;

  @override
  int part2(String input) {
    final grid = parse(input);
    var removed = 0;
    while (true) {
      final removable = findRemovable(grid);
      if (removable.isEmpty) break;
      removed += removable.length;
      for (final point in removable) {
        grid.set(point.x, point.y, '.');
      }
    }
    return removed;
  }
}

void main() => MainRunner().runProblem(AoC2025Day4());
