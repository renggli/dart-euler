import 'dart:io';

import 'package:collection/collection.dart';
import 'package:more/collection.dart';

import 'utils/inputs.dart';
import 'utils/machine.dart';
import 'utils/outputs.dart';

final program =
    File(
      'lib/aoc/2019/dec_23.txt',
    ).readAsStringSync().split(',').map(int.parse).toList();

final computers = List.generate(50, Computer.new);
final nat = QueueList<int>();

class Computer implements Input, Output {
  Computer(int address) {
    incoming.add(address);
  }

  late final Machine machine = Machine(program, input: this, output: this);

  final incoming = QueueList<int>();
  final outgoing = QueueList<int>();

  @override
  int get() => incoming.isEmpty ? -1 : incoming.removeFirst();

  @override
  void put(int value) {
    outgoing.addLast(value);
    if (outgoing case [final addr, final x, final y]) {
      final queue = addr == 255 ? nat : computers[addr].incoming;
      queue.addAll([x, y]);
      outgoing.clear();
    }
  }
}

int problem1() {
  while (true) {
    for (final computer in computers) {
      computer.machine.step();
    }
    if (nat.length == 2) return nat.last;
  }
}

int problem2() {
  var previous = -1;
  while (true) {
    while (nat.length >= 2 &&
        nat.length.isEven &&
        computers.every((computer) => computer.incoming.isEmpty)) {
      if (previous == nat.last) return nat.last;
      previous = nat.last;
      computers[0].incoming.addAll(nat.takeLast(2));
      nat.clear();
    }
    for (final computer in computers) {
      computer.machine.step();
    }
  }
}

void main() {
  assert(problem1() == 21160);
  assert(problem2() == 14327);
}
