import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:data/data.dart';
import 'package:more/more.dart';

final rulesAndUpdates = File(
  'lib/aoc/2024/dec_05.txt',
).readAsStringSync().trim().split('\n\n');
final rules = SetMultimap.fromEntries(
  rulesAndUpdates.first
      .split('\n')
      .map((line) => line.split('|').map(int.parse).toList())
      .map((pair) => MapEntry(pair.first, pair.last)),
);
final updates = rulesAndUpdates.last
    .split('\n')
    .map((line) => line.split(',').map(int.parse).toList())
    .toList();

int comparator(int a, int b) => rules.containsEntry(a, b) ? -1 : 1;

int part1() => updates
    .where(comparator.isStrictlyOrdered)
    .map((update) => update[update.length ~/ 2])
    .sum();

int part2() => updates
    .whereNot(comparator.isStrictlyOrdered)
    .map((update) => update.sorted(comparator))
    .map((update) => update[update.length ~/ 2])
    .sum();

void main() {
  assert(part1() == 3608);
  assert(part2() == 4922);
}
