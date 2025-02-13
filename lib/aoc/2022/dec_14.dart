import 'dart:io';
import 'dart:math';

import 'package:more/more.dart';

const down = Point(0, 1);
const left = Point(-1, 1);
const right = Point(1, 1);

final lines =
    File('lib/aoc/2022/dec_14.txt')
        .readAsLinesSync()
        .map(
          (shape) =>
              shape
                  .split(' -> ')
                  .map(
                    (point) => point
                        .split(',')
                        .map(int.parse)
                        .also((points) => Point(points.first, points.last)),
                  )
                  .toList(),
        )
        .toList();
final rocks =
    <Point>{}..also((data) {
      for (final line in lines) {
        for (final [start, stop] in line.window(2)) {
          final delta = Point((stop.x - start.x).sign, (stop.y - start.y).sign);
          for (var point = start; point != stop; point += delta) {
            data.add(point);
          }
          data.add(stop);
        }
      }
    });

int problem1({Point<int> start = const Point(500, 0)}) {
  final heap = Map.fromIterables(rocks, repeat('#', count: rocks.length));
  final maxY = rocks.map((point) => point.y).max();
  for (var pos = start; pos.y < maxY;) {
    if (!heap.containsKey(pos + down)) {
      pos += down;
    } else if (!heap.containsKey(pos + left)) {
      pos += left;
    } else if (!heap.containsKey(pos + right)) {
      pos += right;
    } else {
      heap[pos] = 'o';
      pos = start;
    }
  }
  return heap.values.count((each) => each == 'o');
}

int problem2({Point<int> start = const Point(500, 0)}) {
  final heap = Map.fromIterables(rocks, repeat('#', count: rocks.length));
  final maxY = rocks.map((point) => point.y).max() + 1;
  for (var pos = start; !heap.containsKey(start);) {
    if (pos.y < maxY && !heap.containsKey(pos + down)) {
      pos += down;
    } else if (pos.y < maxY && !heap.containsKey(pos + left)) {
      pos += left;
    } else if (pos.y < maxY && !heap.containsKey(pos + right)) {
      pos += right;
    } else {
      heap[pos] = 'o';
      pos = start;
    }
  }
  return heap.values.count((each) => each == 'o');
}

void main() {
  assert(problem1() == 779);
  assert(problem2() == 27426);
}
