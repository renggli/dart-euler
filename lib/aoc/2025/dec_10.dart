import 'dart:ffi';
import 'dart:io';

import 'package:collection/collection.dart' show ListEquality;
import 'package:data/data.dart';
import 'package:more/more.dart';
import 'package:petitparser/petitparser.dart';
import 'package:z3/z3.dart' as z3;

final exampleInput = [
  '[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}',
  '[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}',
  '[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}',
];
final puzzleInput = File('lib/aoc/2025/dec_10.txt').readAsLinesSync();

final digits = digit()
    .plus()
    .flatten()
    .map(int.parse)
    .plusSeparated(char(','))
    .map((list) => list.elements);
final parser =
    seq3(
      [char('.').map((_) => false), char('#').map((_) => true)]
          .toChoiceParser()
          .star()
          .skip(before: char('['), after: char(']'))
          .trim(),
      digits.skip(before: char('('), after: char(')')).trim().star(),
      digits.skip(before: char('{'), after: char('}')).trim(),
    ).map3(
      (lights, buttons, joltages) =>
          (lights: lights, buttons: buttons, joltages: joltages),
    );

int solveMachine1(String line) {
  final machine = parser.parse(line).value;
  for (var count = 0; count < machine.buttons.length; count++) {
    // Try all the button press combinations of length 'count'.
    for (final presses in machine.buttons.combinations(count)) {
      final lights = List.filled(machine.lights.length, false);
      for (final press in presses) {
        for (final light in press) {
          lights[light] = !lights[light];
        }
      }
      // Check if we reached the desired state.
      if (const ListEquality<bool>().equals(lights, machine.lights)) {
        return count;
      }
    }
  }
  throw StateError('No combination.');
}

int solveMachine2a(String line) {
  final machine = parser.parse(line).value;
  final maximum = machine.buttons
      .map((buttons) => buttons.map((i) => machine.joltages[i]).min())
      .toList();
  final joltages = List.filled(machine.joltages.length, 0);

  int find({int index = 0, int count = 0}) {
    // First check if we reached a desired state.
    var isEqual = true;
    for (var i = 0; i < machine.joltages.length; i++) {
      if (machine.joltages[i] < joltages[i]) {
        return -1; // already too large
      } else if (joltages[i] < machine.joltages[i]) {
        isEqual = false;
      }
    }
    if (isEqual) return count;
    if (machine.buttons.length <= index) return -1;
    // Find all the best continuations.
    var best = -1;
    final buttons = machine.buttons[index];
    for (var i = 0; i <= maximum[index]; i++) {
      if (i != 0) {
        for (var j = 0; j < buttons.length; j++) {
          joltages[buttons[j]]++;
        }
      }
      final result = find(index: index + 1, count: count + i);
      if (result != -1 && (best == -1 || result < best)) {
        best = result;
      }
    }
    // Restore the old state.
    for (var j = 0; j < buttons.length; j++) {
      joltages[buttons[j]] -= maximum[index];
    }
    return best;
  }

  return find();
}

// Using Z3 constraints solver.
int solveMachine2b(String line) {
  z3.libz3Override = DynamicLibrary.open('/opt/homebrew/lib/libz3.dylib');

  final machine = parser.parse(line).value;
  final solver = z3.optimize();
  final variables = <z3.Expr>[];
  for (var i = 0; i < machine.buttons.length; i++) {
    final variable = z3.constVar('p$i', z3.intSort);
    solver.add(z3.ge(variable, z3.$(0)));
    variables.add(variable);
  }
  for (var i = 0; i < machine.joltages.length; i++) {
    final summands = <z3.Expr>[];
    for (var j = 0; j < machine.buttons.length; j++) {
      if (machine.buttons[j].contains(i)) {
        summands.add(variables[j]);
      }
    }
    solver.add(
      z3.eq(summands.reduce((a, b) => a + b), z3.$(machine.joltages[i])),
    );
  }
  final sum = variables.reduce((a, b) => a + b);
  solver.minimize(sum);
  assert(solver.check() == true, solver.getReasonUnknown());
  return solver.getModel().eval(sum)!.toInt();
}

int part1(List<String> data) => data.map(solveMachine1).sum();

int part2a(List<String> data) => data.map(solveMachine2a).sum();

int part2b(List<String> data) => data.map(solveMachine2b).sum();

void main() {
  assert(part1(exampleInput) == 7);
  assert(part1(puzzleInput) == 481);
  assert(part2a(exampleInput) == 33);
  // Very slow - takes hours to compute all examples.
  // assert(part2a(puzzleInput) == 20142);
  assert(part2b(exampleInput) == 33);
  assert(part2b(puzzleInput) == 20142);
}
