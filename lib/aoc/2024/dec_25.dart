import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_25.txt').readAsStringSync();

final schematics = input
    .split('\n\n')
    .map((schema) => Matrix.fromString(DataType.boolean, schema,
        columnSplitter: '', converter: (char) => char == '#'))
    .toList();
final locks = profile(false);
final keys = profile(true);

List<List<int>> profile(bool isKey) => schematics
    .where((schema) => schema
        .row(isKey ? schema.rowCount - 1 : 0)
        .iterable
        .every(identityFunction))
    .map((schema) => schema.columns
        .map((column) => column.iterable.count(identityFunction) - 1)
        .toList())
    .toList();

bool isFit(List<int> lock, List<int> key) =>
    (lock, key).zip().every((pair) => pair.$1 + pair.$2 <= 5);

int problem1() =>
    [locks, keys].product().count((pair) => isFit(pair.first, pair.last));

void main() {
  assert(problem1() == 3395);
}
