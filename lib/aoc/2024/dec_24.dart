import 'dart:io';
import 'dart:math';

import 'package:more/more.dart';
import 'package:petitparser/petitparser.dart';

final input = File('lib/aoc/2024/dec_24.txt').readAsLinesSync();

final identifier = word().times(3).flatten();
final boolean = pattern('01').map((char) => char == '1');
final valueParser = seq3(
  identifier,
  char(':').trim(),
  boolean,
).map3((id, _, value) => MapEntry<String, Wire>(id, ValueWire(value)));
final operation =
    [
      string('AND').map((_) => Operation.and),
      string('OR').map((_) => Operation.or),
      string('XOR').map((_) => Operation.xor),
    ].toChoiceParser();
final operationParser = seq5(
  identifier,
  operation.trim(),
  identifier,
  string('->').trim(),
  identifier,
).map5((a, op, b, __, c) => MapEntry<String, Wire>(c, OperationWire(a, op, b)));
final parser = [valueParser, operationParser].toChoiceParser();

final wirePrinter = FixedNumberPrinter().padLeft(2, '0');
final decimalPrinter = FixedNumberPrinter(padding: 20);
final binaryPrinter = FixedNumberPrinter(
  base: 2,
  padding: 64,
  separator: ' ',
  separatorWidth: 8,
);

final wires = input
    .where((line) => line.isNotEmpty)
    .map(parser.parse)
    .map((line) => line.value)
    .also(Map.fromEntries);

bool eval(String id) => switch (wires[id]!) {
  ValueWire(value: final value) => value,
  OperationWire(a: final a, op: final op, b: final b) => switch (op) {
    Operation.and => eval(a) && eval(b),
    Operation.or => eval(a) || eval(b),
    Operation.xor => eval(a) != eval(b),
  },
};

void export() {
  final out = File('lib/aoc/2024/dec_24.dot').openWrite();
  out.writeln('digraph {');
  for (final MapEntry(key: id, value: wire) in wires.entries) {
    switch (wire) {
      case ValueWire():
        out.writeln('  $id [label="$id", fillcolor="#eeeeee", style="filled"]');
      case OperationWire(a: final a, op: final op, b: final b):
        final opName = op.toString().skipTo('.');
        final opColor = switch (op) {
          Operation.and => '#aaffff',
          Operation.or => '#ffaaff',
          Operation.xor => '#ffffaa',
        };
        final idColor = id.startsWith('z') ? '#aaffaa' : '#ffffff';
        out.writeln(
          '  ${id}_op [label="$opName", fillcolor="$opColor", '
          'style="filled", shape=box]',
        );
        out.writeln('  $a -> ${id}_op');
        out.writeln('  $b -> ${id}_op');
        out.writeln(
          '  $id [label="$id", fillcolor="$idColor", '
          'style="filled"]',
        );
        out.writeln('  ${id}_op -> $id');
    }
  }
  out.writeln('}');
  out.close();
}

int getValue(String prefix) {
  var value = 0;
  var index = 0;
  while (true) {
    final id = '$prefix${wirePrinter(index)}';
    if (!wires.containsKey(id)) return value;
    value |= (eval(id) ? 1 : 0) << index;
    index++;
  }
}

int problem1() => getValue('z');

void swap(String a, String b) {
  final op1 = wires[a]!;
  final op2 = wires[b]!;
  wires[b] = op1;
  wires[a] = op2;
}

String problem2() {
  // Swaps to perform.
  final swaps = ['wrm', 'wss', 'z29', 'gbs', 'z08', 'thm', 'z22', 'hwq'];
  for (final [a, b] in swaps.chunked(2)) {
    swap(a, b);
  }
  // Output the fixed graph.
  export();
  // Perform some random tests.
  final random = Random(42);
  for (var i = 0; i < 1000; i++) {
    for (var i = 0; i <= 44; i++) {
      wires['x${wirePrinter(i)}'] = ValueWire(random.nextBool());
      wires['y${wirePrinter(i)}'] = ValueWire(random.nextBool());
    }
    final x = getValue('x');
    final y = getValue('y');
    final z = getValue('z');
    final e = x + y;
    if (e != z) {
      stdout.writeln('x: ${decimalPrinter(x)} ${binaryPrinter(x)}');
      stdout.writeln('y: ${decimalPrinter(y)} ${binaryPrinter(y)}');
      stdout.writeln('z: ${decimalPrinter(z)} ${binaryPrinter(z)}');
      stdout.writeln('e: ${decimalPrinter(e)} ${binaryPrinter(e)}');
      stdout.writeln();
    }
  }
  return swaps.toSortedList().join(',');
}

void main() {
  assert(problem1() == 53258032898766);
  assert(problem2() == 'gbs,hwq,thm,wrm,wss,z08,z22,z29');
}

enum Operation { xor, and, or }

sealed class Wire {}

class ValueWire extends Wire {
  ValueWire(this.value);

  bool value;
}

class OperationWire extends Wire {
  OperationWire(this.a, this.op, this.b);

  String a;
  Operation op;
  String b;
}
