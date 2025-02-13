import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final regex = RegExp(r'([DURL]) (\d+) \(#([a-f0-9]{6})\)');
final data = File('lib/aoc/2023/dec_18.txt').readAsLinesSync().toList();

// https://en.wikipedia.org/wiki/Shoelace_formula#Shoelace_formula
int area(Iterable<Point<int>> points) =>
    points
        .window(2)
        .map((p) => p[0].x * p[1].y - p[0].y * p[1].x)
        .sum()
        .abs() ~/
    2;

// https://en.wikipedia.org/wiki/Taxicab_geometry
int border(Iterable<Point<int>> points) =>
    points
        .window(2)
        .map((p) => (p[1].x - p[0].x).abs() + (p[1].y - p[0].y).abs())
        .sum();

int solve(Point<int> Function(Match) direction, int Function(Match) count) {
  final points = data.map((line) => regex.matchAsPrefix(line)!).fold([
    const Point<int>(0, 0),
  ], (list, match) => list..add(list.last + direction(match) * count(match)));
  assert(points.first == points.last, 'Shoelace formula requires closed path');
  return area(points).abs() + border(points) ~/ 2 + 1;
}

const directions1 = {
  'R': Point(0, 1),
  'D': Point(1, 0),
  'L': Point(0, -1),
  'U': Point(-1, 0),
};

int problem1() => solve(
  (match) => directions1[match.group(1)]!,
  (match) => int.parse(match.group(2)!),
);

const directions2 = {
  '0': Point(0, 1),
  '1': Point(1, 0),
  '2': Point(0, -1),
  '3': Point(-1, 0),
};

int problem2() => solve(
  (match) => directions2[match.group(3)!.skip(5)]!,
  (match) => int.parse(match.group(3)!.take(5), radix: 16),
);

void main() {
  assert(problem1() == 46334);
  assert(problem2() == 102000662718092);
}
