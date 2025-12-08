import 'dart:io';

import 'package:collection/collection.dart';
import 'package:data/data.dart';
import 'package:more/more.dart';

final points = File('lib/aoc/2025/dec_08.txt')
    .readAsLinesSync()
    .map((line) => Vector.fromString(DataType.int32, line, splitter: ','))
    .toList();

final edges = points
    .indices()
    .combinations(2, repetitions: false)
    .map(
      (indices) => Edge.undirected(
        indices.first,
        indices.last,
        value: points[indices.first].distanceSquared(points[indices.last]),
      ),
    )
    .sortedBy((edge) => edge.value)
    .toList();

int part1() {
  final sets = DisjointSet(points.indices());
  for (final edge in edges.take(1000)) {
    sets.union(edge.source, edge.target);
  }
  return sets.sizes.sorted(reverseCompare).take(3).product();
}

int part2() {
  final sets = DisjointSet(points.indices());
  for (final edge in edges) {
    if (sets.union(edge.source, edge.target) && sets.count == 1) {
      return points[edge.source][0] * points[edge.target][0];
    }
  }
  throw StateError('No solution found');
}

void main() {
  assert(part1() == 69192);
  assert(part2() == 7264308110);
}
