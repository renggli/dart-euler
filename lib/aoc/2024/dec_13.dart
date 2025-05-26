import 'dart:io';

import 'package:data/data.dart';

final input = File('lib/aoc/2024/dec_13.txt').readAsStringSync();

final digits = RegExp(r'\d+');
final tokens = Vector.fromList(DataType.integer, [3, 1]);

final machines = input
    .split('\n\n')
    .map(
      (machine) =>
          digits.allMatches(machine).map((value) => int.parse(value.group(0)!)),
    )
    .map(
      (values) => (
        buttons: Matrix.fromPackedColumns(
          DataType.integer,
          2,
          2,
          values.take(4).toList(),
        ),
        target: Matrix.fromPackedColumns(
          DataType.integer,
          2,
          1,
          values.skip(4).toList(),
        ),
      ),
    )
    .toList();

int run([int offset = 0]) => machines.map((input) {
  final target =
      input.target + Matrix.constant(DataType.integer, 2, 1, value: offset);
  final solution = input.buttons
      .solve(target)
      .map((_, _, value) => value.round(), DataType.integer);
  return (input.buttons * solution).compare(target)
      ? tokens.dot(solution.column(0))
      : 0;
}).sum();

int problem1() => run();

int problem2() => run(10000000000000);

void main() {
  assert(problem1() == 33921);
  assert(problem2() == 82261957837868);
}
