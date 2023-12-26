import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final graph = File('lib/aoc/2023/dec_25.txt')
    .readAsLinesSync()
    .map((line) => MapEntry(line.takeTo(': '), line.skipTo(': ').split(' ')))
    .also(Map.fromEntries)
    .also(GraphFactory<String, void>(isDirected: false).fromSuccessors);

int problem1() =>
    graph.minCut().graphs.map((graph) => graph.vertices.length).product();

void main() {
  assert(problem1() == 555702);
}
