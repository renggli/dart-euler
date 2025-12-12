import 'package:collection/collection.dart';
import 'package:data/data.dart';
import 'package:more/more.dart';

import '../../utils.dart';

class AoC2025Day8 extends AoC {
  AoC2025Day8() : super(year: 2025, day: 8, part1: 69192, part2: 7264308110);

  List<Vector<int>> parse(String input) => input
      .split('\n')
      .map((line) => Vector.fromString(DataType.int32, line, splitter: ','))
      .toList();

  List<Edge<int, int>> getEdges(List<Vector<int>> points) => points
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

  @override
  int part1(String input) {
    final points = parse(input);
    final edges = getEdges(points);
    final sets = DisjointSet(points.indices());
    for (final edge in edges.take(1000)) {
      sets.union(edge.source, edge.target);
    }
    return sets.sizes.sorted(reverseCompare).take(3).product();
  }

  @override
  int part2(String input) {
    final points = parse(input);
    final edges = getEdges(points);
    final sets = DisjointSet(points.indices());
    for (final edge in edges) {
      if (sets.union(edge.source, edge.target) && sets.count == 1) {
        return points[edge.source][0] * points[edge.target][0];
      }
    }
    throw StateError('No solution found');
  }
}

void main() => MainRunner().runProblem(AoC2025Day8());
