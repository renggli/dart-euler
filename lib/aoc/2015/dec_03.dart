import 'dart:io';
import 'dart:math';

final input = File('lib/aoc/2015/dec_03.txt').readAsLinesSync();

Point<int> move(Point<int> p, String char) => switch (char) {
  '^' => Point(p.x, p.y + 1),
  'v' => Point(p.x, p.y - 1),
  '>' => Point(p.x + 1, p.y),
  '<' => Point(p.x - 1, p.y),
  _ => p,
};

int part1() {
  var current = const Point(0, 0);
  final visited = {current};
  for (final char in input.first.split('')) {
    current = move(current, char);
    visited.add(current);
  }
  return visited.length;
}

int part2() {
  var santa = const Point(0, 0), robo = const Point(0, 0);
  final visited = {santa};
  final chars = input.first.split('');
  for (var i = 0; i < chars.length; i++) {
    if (i.isEven) {
      santa = move(santa, chars[i]);
      visited.add(santa);
    } else {
      robo = move(robo, chars[i]);
      visited.add(robo);
    }
  }
  return visited.length;
}

void main() {
  assert(part1() == 2592);
  assert(part2() == 2360);
}
