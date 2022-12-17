import 'dart:collection';
import 'dart:io';

import 'package:more/more.dart';

final values = File('lib/aoc/2020/dec_23.txt')
    .readAsStringSync()
    .split('')
    .map(int.parse)
    .toList();

class Cup extends LinkedListEntry<Cup> {
  Cup(this.value);

  final int value;

  @override
  Cup get next => super.next ?? list!.first;
}

List<int> run({required int moveCount, int? cupCount}) {
  final ring = LinkedList<Cup>();
  final cups = <int, Cup>{};

  // Create the cups from the input values.
  for (final i in values) {
    ring.add(cups[i] = Cup(i));
  }

  // Add the missing extra cups (problem 2).
  if (cupCount != null) {
    for (var i = values.max() + 1; i <= cupCount; i++) {
      ring.add(cups[i] = Cup(i));
    }
  }

  // Perform all the moves.
  var current = ring.first;
  for (var i = 0; i < moveCount; i++) {
    // (1) Pick up next 3 cups.
    final threeCups = <Cup>[];
    for (var j = 0; j < 3; j++) {
      threeCups.add(current.next..unlink());
    }

    // (2) Select destination cup.
    var destinationValue = current.value - 1;
    if (destinationValue < 1) {
      destinationValue += cups.length;
    }
    while (threeCups.any((cup) => cup.value == destinationValue)) {
      destinationValue--;
      if (destinationValue < 1) {
        destinationValue += cups.length;
      }
    }

    // (3) Place the cups.
    var destinationCup = cups[destinationValue]!;
    for (final cup in threeCups) {
      destinationCup.insertAfter(cup);
      destinationCup = cup;
    }

    // (4) Select the next cup.
    current = current.next;
  }

  // Find the cup with 1.
  while (current.value != 1) {
    current = current.next;
  }
  current = current.next;

  // Get the values of the remaining cups.
  final result = <int>[];
  while (current.value != 1) {
    result.add(current.value);
    current = current.next;
  }
  return result;
}

int problem1() => int.parse(run(moveCount: 100).join());

int problem2() {
  final result = run(moveCount: 10000000, cupCount: 1000000);
  return result[0] * result[1];
}

void main() {
  assert(problem1() == 35827964);
  assert(problem2() == 5403610688);
}
