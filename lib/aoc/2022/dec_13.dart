import 'dart:io';

import 'package:collection/collection.dart';
import 'package:more/more.dart';
import 'package:petitparser/petitparser.dart';

class PacketGrammar extends GrammarDefinition {
  @override
  Parser start() => ref0(value).end();
  Parser value() => ref0(number) | ref0(list);
  Parser number() => digit().plus().flatten().map(int.parse);
  Parser list() => seq3(
    char('['),
    ref0(value).starSeparated(char(',')),
    char(']'),
  ).map3((_, value, _) => value.elements);
}

final parser = PacketGrammar().build();

final input = File('lib/aoc/2022/dec_13.txt')
    .readAsStringSync()
    .split('\n\n')
    .map(
      (block) => block
          .split('\n')
          .map(parser.parse)
          .map((result) => result.value)
          .toList(),
    )
    .toList();

int compare(dynamic a, dynamic b) {
  if (a is int && b is int) {
    return a - b;
  } else if (a is List && b is List) {
    final ia = a.iterator, ib = b.iterator;
    while (ia.moveNext()) {
      if (!ib.moveNext()) {
        return 1;
      }
      final result = compare(ia.current, ib.current);
      if (result != 0) {
        return result;
      }
    }
    return ib.moveNext() ? -1 : 0;
  } else if (a is int && b is List) {
    return compare([a], b);
  } else if (a is List && b is int) {
    return compare(a, [b]);
  }
  throw UnsupportedError('Not supposed to be here');
}

int part1() => input
    .indexed(start: 1)
    .where((entry) => compare(entry.value.first, entry.value.last) < 0)
    .map((entry) => entry.index)
    .sum;

int part2() {
  final markers = [
    [
      [2],
    ],
    [
      [6],
    ],
  ];
  final packages = [...input.flatten(), ...markers].sorted(compare);
  return (packages.indexOf(markers.first) + 1) *
      (packages.indexOf(markers.last) + 1);
}

void main() {
  assert(part1() == 4894);
  assert(part2() == 24180);
}
