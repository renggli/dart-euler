import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2025/dec_06.txt').readAsLinesSync();
final columns = () {
  final result = <List<String>>[];
  final width = input.first.length;
  for (var start = 0, end = 0; end <= width; end++) {
    if (end == width || input.every((line) => line[end] == ' ')) {
      result.add(input.map((line) => line.substring(start, end)).toList());
      start = end + 1;
    }
  }
  return result;
}();

int solve(Iterable<int> Function(List<String>) extract) =>
    columns.map((column) {
      final operands = extract(column.sublist(0, column.length - 1));
      return column.last.trim() == '+' ? operands.sum() : operands.product();
    }).sum();

int part1() => solve((values) => values.map(int.parse));

int part2() => solve(
  (rows) => 0
      .to(rows.first.length)
      .reversed
      .map((i) => int.parse(rows.map((row) => row[i]).join())),
);

void main() {
  assert(part1() == 4364617236318);
  assert(part2() == 9077004354241);
}
