import 'dart:collection';
import 'dart:io';
import 'package:more/more.dart';

final values =
    File('lib/aoc2020/dec_15.txt').readAsStringSync().split(',').map(int.parse);

int run(int count) {
  final lastSpoken = values
      .indexed()
      .toMap(key: (each) => each.value, value: (each) => each.index + 1);
  var lastValue = values.last;
  for (var i = values.length; i < count; i++) {
    final value =
        lastSpoken.containsKey(lastValue) ? i - lastSpoken[lastValue]! : 0;
    lastSpoken[lastValue] = i;
    lastValue = value;
  }
  return lastValue;
}

void main() {
  assert(run(2020) == 763);
  assert(run(30000000) == 1876406);
}
