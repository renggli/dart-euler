import 'dart:io';

import 'package:collection/collection.dart';

import 'utils/machine.dart';

final input = File('lib/aoc/2024/dec_17.txt').readAsStringSync();
final values = RegExp(
  r'\d+',
).allMatches(input).map((each) => each[0]!).map(int.parse);
final registers = values.take(3).toList();
final program = values.skip(3).toList();

String part1() => Machine(registers, program).run().join(',');

List<int> run(int a) => Machine([a, ...registers.skip(1)], program).run();

int part2() {
  var register = 0;
  const equality = ListEquality<int>();
  for (var start = program.length - 1; start >= 0; start--) {
    var current = register << 3;
    final expected = program.sublist(start);
    while (true) {
      final output = run(current);
      if (equality.equals(output, expected)) {
        register = current;
        break;
      }
      current++;
    }
  }
  assert(equality.equals(run(register), program));
  return register;
}

void main() {
  assert(part1() == '2,3,6,2,1,6,1,2,1');
  assert(part2() == 90938893795561);
}
