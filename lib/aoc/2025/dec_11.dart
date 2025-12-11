import 'dart:io';

import 'package:data/stats.dart';

final exampleInput1 = [
  'aaa: you hhh',
  'you: bbb ccc',
  'bbb: ddd eee',
  'ccc: ddd eee fff',
  'ddd: ggg',
  'eee: out',
  'fff: out',
  'ggg: out',
  'hhh: ccc fff iii',
  'iii: out',
];
final exampleInput2 = [
  'svr: aaa bbb',
  'aaa: fft',
  'fft: ccc',
  'bbb: tty',
  'tty: ccc',
  'ccc: ddd eee',
  'ddd: hub',
  'hub: fff',
  'eee: dac',
  'dac: fff',
  'fff: ggg hhh',
  'ggg: out',
  'hhh: out',
];
final puzzleInput = File('lib/aoc/2025/dec_11.txt').readAsLinesSync();

Map<String, List<String>> parseData(List<String> input) {
  final graph = <String, List<String>>{};
  for (final line in input) {
    final parts = line.split(': ');
    graph[parts[0]] = parts[1].split(' ');
  }
  return graph;
}

int countPaths(
  Map<String, List<String>> graph,
  String source,
  String target, [
  Map<String, int>? cache,
]) {
  if (source == target) return 1;
  if ((cache ??= {})[source] case final count?) return count;
  return cache[source] = (graph[source] ?? [])
      .map((neighbor) => countPaths(graph, neighbor, target, cache))
      .sum();
}

int part1(List<String> data) => countPaths(parseData(data), 'you', 'out');

int part2(List<String> data) {
  final graph = parseData(data);
  final path1 =
      countPaths(graph, 'svr', 'dac') *
      countPaths(graph, 'dac', 'fft') *
      countPaths(graph, 'fft', 'out');
  final path2 =
      countPaths(graph, 'svr', 'fft') *
      countPaths(graph, 'fft', 'dac') *
      countPaths(graph, 'dac', 'out');
  return path1 + path2;
}

void main() {
  assert(part1(exampleInput1) == 5);
  assert(part1(puzzleInput) == 772);

  assert(part2(exampleInput2) == 2);
  assert(part2(puzzleInput) == 423227545768872);
}
