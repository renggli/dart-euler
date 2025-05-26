import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/collection.dart';

const size = 25;
final values = File(
  'lib/aoc/2020/dec_09.txt',
).readAsLinesSync().map(int.parse).toList();

bool canSum(List<int> window, int value) {
  for (final a in window) {
    for (final b in window) {
      if (a + b == value) {
        return true;
      }
    }
  }
  return false;
}

void main() {
  late int invalid;
  for (var i = 0; i < values.length - size; i++) {
    final window = values.sublist(i, i + size);
    final value = values[i + size];
    if (!canSum(window, value)) {
      invalid = value;
      break;
    }
  }
  assert(invalid == 756008079);

  late int weakness;
  start:
  for (var i = 0; i < values.length; i++) {
    for (var j = i + 1; j < values.length; j++) {
      final sequence = values.sublist(i, j);
      final sum = sequence.sum();
      if (sum == invalid) {
        weakness = sequence.min() + sequence.max();
        break start;
      } else if (sum > invalid) {
        continue start;
      }
    }
  }
  assert(weakness == 93727241);
}
