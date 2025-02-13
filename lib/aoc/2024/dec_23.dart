import 'dart:io';

import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_23.txt').readAsLinesSync();
final graph =
    Graph<String, void>.undirected()..also((graph) {
      for (final [source, target] in input.map((line) => line.split('-'))) {
        graph.addEdge(source, target);
      }
    });

int problem1() =>
    graph
        .findCliques()
        .where((clique) => clique.length >= 3)
        .flatMap((clique) => clique.combinations(3))
        .where((clique) => clique.any((each) => each.startsWith('t')))
        .map((clique) => clique.join(','))
        .unique()
        .length;

String problem2() => graph
    .findCliques()
    .max(comparator: delegateComparator((list) => list.length as num))
    .toSortedList()
    .join(',');

void main() {
  assert(problem1() == 1154);
  assert(problem2() == 'aj,ds,gg,id,im,jx,kq,nj,ql,qr,ua,yh,zn');
}
