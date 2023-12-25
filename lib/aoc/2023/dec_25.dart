import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/more.dart';

final graph = File('lib/aoc/2023/dec_25.txt')
    .readAsLinesSync()
    .map((line) => MapEntry(line.takeTo(': '), line.skipTo(': ').split(' ')))
    .also(Map.fromEntries)
    .also(GraphFactory<String, void>(isDirected: false).fromSuccessors);

int problem1() {
  // From visually inspecting the graph using `graph.toDot()`.
  graph.removeEdge('rfq', 'lsk');
  graph.removeEdge('zhg', 'qdv');
  graph.removeEdge('prk', 'gpz');

  final connected = graph.connected().toList();
  assert(connected.length == 2);
  return connected.map((subgraph) => subgraph.vertices.length).product();
}

void main() {
  assert(problem1() == 555702);
}
