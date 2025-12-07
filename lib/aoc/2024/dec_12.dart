import 'dart:collection' show Queue;
import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_12.txt').readAsStringSync();
final grid = Matrix.fromString(DataType.string, input, columnSplitter: '');

const directions = [Point(0, 1), Point(1, 0), Point(0, -1), Point(-1, 0)];

Set<Point<int>> floodFill(Point<int> start) {
  final result = <Point<int>>{start};
  final queue = Queue<Point<int>>.of(result);
  final value = grid.get(start.x, start.y);
  while (queue.isNotEmpty) {
    final point = queue.removeFirst();
    for (final offset in directions) {
      final neighbour = point + offset;
      if (grid.isWithinBounds(neighbour.x, neighbour.y) &&
          grid.getUnchecked(neighbour.x, neighbour.y) == value &&
          result.add(neighbour)) {
        queue.addLast(neighbour);
      }
    }
  }
  return result;
}

List<Set<Point<int>>> areas() {
  final seen = <Point<int>>{};
  final areas = <Set<Point<int>>>[];
  for (final (:row, :col, value: _) in grid.rowMajor) {
    final point = Point(row, col);
    if (!seen.contains(point)) {
      final area = floodFill(point);
      seen.addAll(area);
      areas.add(area);
    }
  }
  return areas;
}

int perimeter(Set<Point<int>> area) => area
    .flatMap((point) => directions.map((offset) => point + offset))
    .count((neighbour) => !area.contains(neighbour));

int corners(Set<Point<int>> area, Point<int> point) {
  var count = 0;
  for (final d in directions.indices()) {
    // Point P is in an outward pointing corner?
    //
    //     !  ?
    //     P  !
    //
    if (!area.contains(point + directions[d]) &&
        !area.contains(point + directions[(d + 1) % 4])) {
      count++;
    }
    // Point P is on an inward pointing corner?
    //
    //     p  !
    //     P  p
    //
    else if (area.contains(point + directions[d]) &&
        !area.contains(point + directions[d] + directions[(d + 1) % 4]) &&
        area.contains(point + directions[(d + 1) % 4])) {
      count++;
    }
  }
  return count;
}

int sides(Set<Point<int>> area) =>
    area.map((point) => corners(area, point)).sum();

int part1() => areas().map((area) => area.length * perimeter(area)).sum();

int part2() => areas().map((area) => area.length * sides(area)).sum();

void main() {
  assert(part1() == 1486324);
  assert(part2() == 898684);
}
