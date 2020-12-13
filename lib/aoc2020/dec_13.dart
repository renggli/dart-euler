import 'dart:io';

import 'package:more/more.dart';

final values = File('lib/aoc2020/dec_13.txt').readAsLinesSync();

final start = int.parse(values[0]);
final buses = values[1]
    .split(',')
    .indexed()
    .where((each) => each.value != 'x')
    .toMap(key: (each) => each.index, value: (each) => int.parse(each.value));

int solution1() {
  for (var t = start;; t++) {
    for (final bus in buses.values) {
      if (t % bus == 0) {
        return bus * (t - start);
      }
    }
  }
}

int solution2() {
  var start = 0;
  var product = 1;
  for (final bus in buses.entries) {
    while ((start + bus.key) % bus.value != 0) {
      start += product;
    }
    product *= bus.value;
  }
  return start;
}

void main() {
  assert(solution1() == 203);
  assert(solution2() == 905694340256752);
}
