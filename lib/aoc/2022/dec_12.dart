import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:data/matrix.dart';
import 'package:data/type.dart';

final input = File('lib/aoc/2022/dec_12.txt').readAsLinesSync();
final source = Matrix.generate(DataType.string, input.length, input[0].length,
    (row, column) => input[row][column],
    format: MatrixFormat.columnMajor);
final height = Matrix.generate(DataType.int32, source.rowCount, source.colCount,
    (row, column) {
  var char = source.get(row, column);
  if (char == 'S') char = 'a';
  if (char == 'E') char = 'z';
  return char.codeUnitAt(0) - 'a'.codeUnitAt(0);
});
final start = findPoints(source, 'S').single;
final end = findPoints(source, 'E').single;

Iterable<Point<int>> findPoints<T>(Matrix<T> matrix, T value) sync* {
  for (var r = 0; r < matrix.rowCount; r++) {
    for (var c = 0; c < matrix.colCount; c++) {
      if (matrix.get(r, c) == value) {
        yield Point(r, c);
      }
    }
  }
}

const directions = <Point<int>>[
  Point(-1, 0),
  Point(1, 0),
  Point(0, -1),
  Point(0, 1),
];

class Node<T> implements Comparable<Node<T>> {
  Node(this.state, {this.parent, this.cost = 0});

  final T state;
  Node<T>? parent;
  num cost;

  List<T> get path {
    final path = <T>[];
    for (Node<T>? current = this; current != null; current = current.parent) {
      path.add(current.state);
    }
    path.reverseRange(0, path.length);
    return path;
  }

  @override
  int compareTo(Node<T> other) => cost.compareTo(other.cost);
}

List<T> search<T>({
  required T start,
  required bool Function(T node) isGoal,
  required Iterable<T> Function(T node) expand,
  required num Function(T source, T target) cost,
}) {
  final startNode = Node<T>(start);
  final reached = <T, Node<T>>{startNode.state: startNode};
  final frontier = PriorityQueue<Node<T>>()..add(startNode);
  while (frontier.isNotEmpty) {
    final currentNode = frontier.removeFirst();
    if (isGoal(currentNode.state)) {
      return currentNode.path;
    }
    for (final next in expand(currentNode.state)) {
      final nextCost = currentNode.cost + cost(currentNode.state, next);
      if (!reached.containsKey(next) || nextCost < reached[next]!.cost) {
        final nextNode = Node<T>(next, parent: currentNode, cost: nextCost);
        reached[next] = nextNode;
        frontier.add(nextNode);
      }
    }
  }
  return [];
}

int findStepCount(Point<int> start) =>
    search(
        start: start,
        isGoal: (point) => point == end,
        expand: (point) => directions
            .map((each) => each + point)
            .where((each) => height.isWithinBounds(each.x, each.y)),
        cost: (a, b) {
          final diff = height.get(b.x, b.y) - height.get(a.x, a.y);
          return diff == 0 || diff == 1 ? 1 : double.infinity;
        }).length -
    1;

void main() {
  assert(findStepCount(start) == 319);
  print(findPoints(source, 'a').map(findStepCount).toList().min);
}
