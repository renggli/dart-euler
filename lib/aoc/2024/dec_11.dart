import 'dart:io';
import 'dart:math';

import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_11.txt').readAsStringSync();
final stones = input.trim().split(' ').map(int.parse).toList();

Iterable<int> next(int stone) {
  // If the stone is engraved with the number 0, it is replaced by a stone
  // engraved with the number 1.
  if (stone == 0) return const [1];
  // If the stone is engraved with a number that has an even number of digits,
  // it is replaced by two stones. The left half of the digits are engraved on
  // the new left stone, and the right half of the digits are engraved on the
  // new right stone.
  var digits = 1;
  while (stone >= pow(10, digits)) {
    digits++;
  }
  if (digits.isEven) {
    final base = pow(10, digits ~/ 2).round();
    return [stone ~/ base, stone % base];
  }
  // If none of the other rules apply, the stone is replaced by a new stone; the
  // old stone's number multiplied by 2024 is engraved on the new stone.
  return [2024 * stone];
}

int run(int blink) {
  var currentStones = Multiset<int>.from(stones);
  for (var i = 0; i < blink; i++) {
    final newStones = Multiset<int>();
    for (final MapEntry(key: stone, value: count) in currentStones.entrySet) {
      for (final newStone in next(stone)) {
        newStones[newStone] += count;
      }
    }
    currentStones = newStones;
  }
  return currentStones.length;
}

int problem1() => run(25);
int problem2() => run(75);

void main() {
  assert(problem1() == 224529);
  assert(problem2() == 266820198587914);
}
