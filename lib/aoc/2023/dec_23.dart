import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final matrix = File('lib/aoc/2023/dec_23.txt').readAsLinesSync().also(
  (rows) => Matrix.fromPackedRows(
    DataType.string,
    rows.length,
    rows[0].length,
    rows.expand((line) => line.split('')).toList(),
  ),
);
const start = Point(0, 1);
final stop = Point(matrix.rowCount - 1, matrix.colCount - 2);

const slopes = {
  '^': Point(-1, 0),
  '>': Point(0, 1),
  'v': Point(1, 0),
  '<': Point(0, -1),
};

Graph<Point<int>, int> buildGraph(
  Matrix<String> matrix, {
  required bool withSlopes,
}) =>
    GraphFactory<Point<int>, int>(
      isDirected: true,
      edgeProvider: constantFunction2(1),
    ).fromSuccessorFunction([start], (vertex) {
      final type = matrix.get(vertex.x, vertex.y);
      if (withSlopes && slopes[type] != null) return [vertex + slopes[type]!];
      return slopes.values
          .map((offset) => vertex + offset)
          .where(
            (point) =>
                matrix.isWithinBounds(point.x, point.y) &&
                matrix.get(point.x, point.y) != '#',
          );
    });

Graph<Point<int>, int> compress(
  Graph<Point<int>, int> graph,
  Set<Point<int>> preserve,
) {
  var changed = false;
  do {
    changed = false;
    for (final vertex in [...graph.vertices]) {
      if (!preserve.contains(vertex)) {
        final neighbours = graph.neighboursOf(vertex).unique().toList();
        if (neighbours.length == 2) {
          final a = graph.getEdge(neighbours[0], vertex);
          final b = graph.getEdge(vertex, neighbours[1]);
          if (a != null && b != null) {
            graph.removeEdge(a.source, a.target);
            graph.removeEdge(b.source, b.target);
            graph.addEdge(a.source, b.target, value: a.value + b.value);
            changed = true;
          }
        }
        if (graph.neighboursOf(vertex).length <= 1) {
          graph.removeVertex(vertex);
        }
      }
    }
  } while (changed);
  return graph;
}

int findLongestPath(
  Graph<Point<int>, int> graph,
  Point<int> vertex, {
  Set<Point<int>>? seen,
  int maxLength = 0,
  int vertexLength = 0,
}) {
  if (vertex == stop) return max(maxLength, vertexLength);
  seen ??= {};
  seen.add(vertex);
  for (final point in graph.successorsOf(vertex)) {
    if (!seen.contains(point)) {
      maxLength = findLongestPath(
        graph,
        point,
        seen: seen,
        maxLength: maxLength,
        vertexLength: vertexLength + graph.getEdge(vertex, point)!.value,
      );
    }
  }
  seen.remove(vertex);
  return maxLength;
}

int problem1() => findLongestPath(
  compress(buildGraph(matrix, withSlopes: true), {start, stop}),
  start,
);

int problem2() => findLongestPath(
  compress(buildGraph(matrix, withSlopes: false), {start, stop}),
  start,
);

void main() {
  assert(problem1() == 1998);
  assert(problem2() == 6434);
}
