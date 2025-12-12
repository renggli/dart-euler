import 'package:data/data.dart';
import 'package:more/more.dart';

import '../../utils.dart';

class AoC2025Day6 extends AoC {
  AoC2025Day6()
    : super(year: 2025, day: 6, part1: 4364617236318, part2: 9077004354241);

  List<List<String>> parse(String input) {
    final lines = input.split('\n');
    final result = <List<String>>[];
    final width = lines.first.length;
    for (var start = 0, end = 0; end <= width; end++) {
      if (end == width || lines.every((line) => line[end] == ' ')) {
        result.add(lines.map((line) => line.substring(start, end)).toList());
        start = end + 1;
      }
    }
    return result;
  }

  int solve(
    List<List<String>> columns,
    Iterable<int> Function(List<String>) extract,
  ) => columns.map((column) {
    final operands = extract(column.sublist(0, column.length - 1));
    return column.last.trim() == '+' ? operands.sum() : operands.product();
  }).sum();

  @override
  int part1(String input) =>
      solve(parse(input), (values) => values.map(int.parse));

  @override
  int part2(String input) => solve(
    parse(input),
    (rows) => 0
        .to(rows.first.length)
        .reversed
        .map((i) => int.parse(rows.map((row) => row[i]).join())),
  );
}

void main() => MainRunner().runProblem(AoC2025Day6());
