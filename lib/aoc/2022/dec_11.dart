import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/collection.dart';
import 'package:more/more.dart';

final monkeyPattern = RegExp(r'''Monkey (\d+):
  Starting items: (.+)
  Operation: new = old (.) (.+)
  Test: divisible by (\d+)
    If true: throw to monkey (\d+)
    If false: throw to monkey (\d+)''', multiLine: true);

class Monkey {
  Monkey(String input) : this._(monkeyPattern.matchAsPrefix(input)!);

  Monkey._(Match match)
    : index = int.parse(match.group(1)!),
      startItems = match.group(2)!.split(',').map(int.parse),
      operation = match.group(3) == '+'
          ? ((a, b) => a + b)
          : match.group(3) == '*'
          ? ((a, b) => a * b)
          : throw ArgumentError(),
      operator = int.tryParse(match.group(4) ?? ''),
      divisor = int.parse(match.group(5)!),
      trueTarget = int.parse(match.group(6)!),
      falseTarget = int.parse(match.group(7)!);

  final int index;
  final Iterable<int> startItems;
  final int Function(int, int) operation;
  final int? operator;
  final int divisor;
  final int trueTarget;
  final int falseTarget;
}

final monkeys = File(
  'lib/aoc/2022/dec_11.txt',
).readAsStringSync().split('\n\n').map(Monkey.new).toList();

void round(
  List<List<int>> monkeyItems,
  List<int> monkeyInspections,
  int modulo,
  int divisor,
) {
  for (final monkey in monkeys) {
    final items = monkeyItems[monkey.index];
    for (final item in items) {
      final value = monkey.operation(item, monkey.operator ?? item) ~/ divisor;
      final target = value % monkey.divisor == 0
          ? monkey.trueTarget
          : monkey.falseTarget;
      monkeyItems[target].add(value % modulo);
    }
    monkeyInspections[monkey.index] += items.length;
    items.clear();
  }
}

int run(int rounds, int divisor) {
  final monkeyItems = List.generate(
    monkeys.length,
    (i) => monkeys[i].startItems.toList(),
  );
  final monkeyInspections = List.filled(monkeys.length, 0);
  final modulo = monkeys.map((monkey) => monkey.divisor).product();
  for (var i = 0; i < rounds; i++) {
    round(monkeyItems, monkeyInspections, modulo, divisor);
  }
  return monkeyInspections.largest(2).product();
}

void main() {
  assert(run(20, 3) == 113220);
  assert(run(10000, 1) == 30599555965);
}
