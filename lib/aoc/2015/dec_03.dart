import 'dart:io';
import 'dart:math';

final input = File('lib/aoc/2015/dec_03.txt').readAsLinesSync();

int problem1() {
  var currentX = 0;
  var currentY = 0;
  final visitedHouses = <Point<int>>{};
  visitedHouses.add(Point(currentX, currentY));

  final directions = input.first;
  for (final direction in directions.split('')) {
    switch (direction) {
      case '^':
        currentY++;
      case 'v':
        currentY--;
      case '>':
        currentX++;
      case '<':
        currentX--;
    }
    visitedHouses.add(Point(currentX, currentY));
  }
  return visitedHouses.length;
}

int problem2() => 0;

void main() {
  assert(problem1() == 2592);
  print('Problem 2: ${problem2()}');
}
