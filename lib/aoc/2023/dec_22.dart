import 'dart:io';

import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef Cube = ({int x, int y, int z});

class Brick {
  factory Brick.fromString(int index, String input) {
    final [x1, y1, z1, x2, y2, z2] = input
        .split(CharMatcher.charSet(',~'))
        .map(int.parse)
        .toList();
    assert(x1 <= x2 && y1 <= y2 && z1 <= z2, 'coordinates not sorted');
    final cubes = <Cube>[];
    for (var x = x1; x <= x2; x++) {
      for (var y = y1; y <= y2; y++) {
        for (var z = z1; z <= z2; z++) {
          cubes.add((x: x, y: y, z: z));
        }
      }
    }
    return Brick(index, cubes);
  }

  Brick(this.index, Iterable<Cube> cubes)
    : cubes = cubes.toList(growable: false);

  final int index;
  final List<Cube> cubes;

  int get min => cubes.first.z;

  bool canDrop(Set<Cube> blocked) =>
      min > 1 && dropped.cubes.none(blocked.contains);

  Brick get dropped =>
      Brick(index, cubes.map((cube) => (x: cube.x, y: cube.y, z: cube.z - 1)));

  @override
  toString() => 'Blocks($index: ${cubes.join(', ')})';
}

final bricks = File(
  'lib/aoc/2023/dec_22.txt',
).readAsLinesSync().mapIndexed(Brick.fromString).toList();

List<Brick> drop(List<Brick> bricks) {
  final blocked = <Cube>{};
  return bricks.map((brick) {
    while (brick.canDrop(blocked)) {
      brick = brick.dropped;
    }
    blocked.addAll(brick.cubes);
    return brick;
  }).toList();
}

void main() {
  var problem1 = 0, problem2 = 0;
  final dropped = drop(bricks.sortedBy<num>((brick) => brick.min));
  final indexed = dropped.sortedBy<num>((brick) => brick.index);
  for (var i = 0; i < dropped.length; i++) {
    final updated = drop(dropped.toList()..removeAt(i));
    final moved = updated.count(
      (brick) => indexed[brick.index].min != brick.min,
    );
    if (moved == 0) problem1++;
    problem2 += moved;
  }
  assert(problem1 == 517);
  assert(problem2 == 61276);
}
