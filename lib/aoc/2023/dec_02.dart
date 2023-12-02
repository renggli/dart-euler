import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_02.txt').readAsLinesSync().toMap(
    key: (line) => int.parse(line.skipTo(' ').takeTo(':')),
    value: (line) => line
        .skipTo(': ')
        .split('; ')
        .map((set) => Multiset<String>.fromIterable(
              set.split(', '),
              key: (each) => (each as String).skipTo(' '),
              count: (each) => int.parse((each as String).takeTo(' ')),
            ))
        .toList());

final expected = Multiset<String>()
  ..add('red', 12)
  ..add('green', 13)
  ..add('blue', 14);

void main() {
  assert(data.entries
          .where((game) => game.values.every(expected.containsAll))
          .map((entry) => entry.key)
          .sum() ==
      2085);
  assert(data.entries
          .map((entry) =>
              entry.values.reduce((a, b) => a.maximum(b)).counts.product())
          .sum() ==
      79315);
}
