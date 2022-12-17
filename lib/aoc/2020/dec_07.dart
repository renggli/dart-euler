import 'dart:io';

import 'package:more/more.dart';

final trimmer = CharMatcher.charSet('s.');

final values = File('lib/aoc/2020/dec_07.txt')
    .readAsLinesSync()
    .map((each) => each.split(' contain '))
    .toMap(
        key: (each) => trimmer.trimTailingFrom(each[0]),
        value: (each) => each[1]
            .split(', ')
            .where((each) => !each.startsWith('no other bags'))
            .toMap(
                key: (each) => trimmer.trimTailingFrom(each.substring(2)),
                value: (each) => int.parse(each[0])));

void collectContainingBags(String start, Set<String> result) => values.entries
    .where((each) => each.value.containsKey(start))
    .where((each) => result.add(each.key))
    .forEach((each) => collectContainingBags(each.key, result));

void collectInsideBags(int count, String start, Multiset<String> result) =>
    values[start]!.forEach((key, value) {
      result.add(key, count * value);
      collectInsideBags(count * value, key, result);
    });

void main() {
  final containing = <String>{};
  collectContainingBags('shiny gold bag', containing);
  assert(containing.length == 164);

  final inside = <String>[].toMultiset();
  collectInsideBags(1, 'shiny gold bag', inside);
  assert(inside.length == 7872);
}
