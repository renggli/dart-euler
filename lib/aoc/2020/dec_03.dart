import 'dart:io';

final map = File('lib/aoc/2020/dec_03.txt').readAsLinesSync();

bool hasTree(int x, int y) {
  final line = map[y];
  final point = line[x % line.length];
  return point == '#';
}

int countTrees(int slopeX, int slopeY) {
  var count = 0;
  for (var x = 0, y = 0; y < map.length; x += slopeX, y += slopeY) {
    if (hasTree(x, y)) {
      count++;
    }
  }
  return count;
}

void main() {
  assert(countTrees(3, 1) == 220);
  assert(
    countTrees(1, 1) *
            countTrees(3, 1) *
            countTrees(5, 1) *
            countTrees(7, 1) *
            countTrees(1, 2) ==
        2138320800,
  );
}
