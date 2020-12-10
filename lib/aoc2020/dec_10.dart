import 'dart:collection';
import 'dart:io';

import 'package:more/more.dart';

final values =
    File('lib/aoc2020/dec_10.txt').readAsLinesSync().map(int.parse).toList();

final cache = <int, int>{};

int arrangements(int index) => cache.putIfAbsent(index, () {
      if (index < values.length - 1) {
        var count = 0;
        for (var i = index + 1;
            i < values.length && values[i] - values[index] <= 3;
            i++) {
          count += arrangements(i);
        }
        return count;
      } else {
        return 1;
      }
    });

void main() {
  // preparation
  values
    ..add(0)
    ..add(values.max() + 3)
    ..sort();

  // puzzle 1
  final differences =
      values.window(2).map((each) => each[1] - each[0]).toMultiset();
  assert(differences[1] * differences[3] == 1755);

  // puzzle 2
  assert(arrangements(0) == 4049565169664);
}
