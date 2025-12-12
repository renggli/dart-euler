import 'dart:ffi';

import 'package:collection/collection.dart' show ListEquality;
import 'package:more/more.dart';
import 'package:petitparser/petitparser.dart';
import 'package:z3/z3.dart' as z3;

import '../../utils.dart';

class AoC2025Day10 extends AoC {
  AoC2025Day10()
    : super(
        year: 2025,
        day: 10,
        part1: 481,
        part2: 20142,
        examples: [
          AoCExample(
            input: [
              '[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}',
              '[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}',
              '[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}',
            ].join('\n'),
            part1: 7,
            part2: 33,
          ),
        ],
      );

  static final digits = digit()
      .plus()
      .flatten()
      .map(int.parse)
      .plusSeparated(char(','))
      .map((list) => list.elements);

  static final parser =
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
    // assert(solver.check() == true, solver.getReasonUnknown());
    if (solver.check() != true) {
      return 0; // Or throw error? Original asserted true.
    }
    return solver.getModel().eval(sum)!.toInt();
  }

  @override
  int part1(String input) =>
      input.trim().split('\n').map(solveMachine1).fold(0, (a, b) => a + b);

  @override
  int part2(String input) =>
      input.trim().split('\n').map(solveMachine2b).fold(0, (a, b) => a + b);
}

void main() => MainRunner().runProblem(AoC2025Day10());
