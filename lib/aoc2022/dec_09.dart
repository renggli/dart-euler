import 'dart:io';
import 'dart:math';

enum Direction {
  up(Point(0, 1)),
  down(Point(0, -1)),
  left(Point(-1, 0)),
  right(Point(1, 0));

  const Direction(this.offset);

  final Point<int> offset;
}

const directions = {
  'U': Direction.up,
  'D': Direction.down,
  'L': Direction.left,
  'R': Direction.right,
};

class Move {
  Move(String input)
      : direction = directions[input[0]]!,
        count = int.parse(input.substring(2));

  final Direction direction;

  final int count;
}

Set<Point> run(Iterable<Move> moves, int knots) {
  final tails = <Point<int>>{};
  final rope = List.generate(knots, (_) => const Point(0, 0));
  for (var move in moves) {
    for (var i = 0; i < move.count; i++) {
      rope[0] += move.direction.offset;
      for (var j = 1; j < knots; j++) {
        final delta = rope[j - 1] - rope[j];
        if (delta.magnitude > sqrt2) {
          if (delta.x != 0) rope[j] += Point(delta.x ~/ delta.x.abs(), 0);
          if (delta.y != 0) rope[j] += Point(0, delta.y ~/ delta.y.abs());
        }
      }
      tails.add(rope.last);
    }
  }
  return tails;
}

final moves =
    File('lib/aoc2022/dec_09.txt').readAsLinesSync().map((line) => Move(line));

void main() {
  assert(run(moves, 2).length == 5930);
  assert(run(moves, 10).length == 2443);
}
