import 'dart:io';

import 'utils/machine.dart';
import 'utils/outputs.dart';

final file = File('lib/aoc/2019/dec_17.txt');

class State implements Output {
  final List<List<String>> data = [[]];

  @override
  void put(int value) {
    if (value == 10) {
      data.add([]);
    } else {
      data.last.add(String.fromCharCode(value));
    }
  }
}

final data = () {
  final state = State();
  Machine.fromFile(file, output: state).run();
  while (state.data.last.isEmpty) {
    state.data.removeLast();
  }
  return state.data;
}();

int problem1() {
  var result = 0;
  for (var x = 1; x < data.length - 1; x++) {
    for (var y = 1; y < data[x].length - 1; y++) {
      if (data[x][y] == '#' &&
          data[x - 1][y] == '#' &&
          data[x][y - 1] == '#' &&
          data[x + 1][y] == '#' &&
          data[x][y + 1] == '#') {
        result += x * y;
      }
    }
  }
  return result;
}

int problem2() => 0;

void main() {
  assert(problem1() == 13580);
  print(problem2());
}
