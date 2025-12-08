import 'dart:io';

import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_23.txt').readAsLinesSync();
final graph = Graph<String, void>(isDirected: false)
  ..also((graph) {
    for (final [source, target] in input.map((line) => line.split('-'))) {
      graph.addEdge(source, target);
    }
  });

int part1() => graph
    .findCliques()
    .where((clique) => clique.length >= 3)
    .flatMap((clique) => clique.combinations(3))
    .where((clique) => clique.any((each) => each.startsWith('t')))
    .map((clique) => clique.join(','))
    .unique()
    .length;

String part2() => graph
    .findCliques()
    .max(comparator: keyOf((list) => list.length as num))
    .toSortedList()
    .join(',');

void main() {
  assert(part1() == 1154);
  assert(part2() == 'aj,ds,gg,id,im,jx,kq,nj,ql,qr,ua,yh,zn');
}
