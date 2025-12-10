import 'dart:io';

import 'package:collection/collection.dart' show ListEquality;
import 'package:data/data.dart';
import 'package:more/more.dart';
import 'package:petitparser/petitparser.dart';

final exampleInput = [
  '[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}',
  '[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}',
  '[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}',
];
final puzzleInput = File('lib/aoc/2025/dec_10.txt').readAsLinesSync();

final parser =
    seq3(
      [char('.').map((_) => false), char('#').map((_) => true)]
          .toChoiceParser()
          .star()
          .skip(before: char('['), after: char(']'))
          .trim(),
      digit()
          .plus()
          .flatten()
          .map(int.parse)
          .plusSeparated(char(','))
          .map((list) => list.elements)
          .skip(before: char('('), after: char(')'))
          .trim()
          .star(),
      digit()
          .plus()
          .flatten()
          .map(int.parse)
          .plusSeparated(char(','))
          .map((list) => list.elements)
          .skip(before: char('{'), after: char('}'))
          .trim(),
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

int solveMachine2(String line) => 0;

int part1(List<String> data) => data.map(solveMachine1).sum();

int part2(List<String> data) => data.map(solveMachine2).sum();

void main() {
  assert(part1(exampleInput) == 7);
  assert(part1(puzzleInput) == 481);

  assert(part2(exampleInput) == 33);
  print(part2(puzzleInput));
}
