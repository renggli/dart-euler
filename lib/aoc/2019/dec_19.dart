import 'dart:io';
import 'dart:math';

import 'utils/inputs.dart';
import 'utils/machine.dart';
import 'utils/outputs.dart';

final memory = File(
  'lib/aoc/2019/dec_19.txt',
).readAsStringSync().split(',').map(int.parse).toList();

bool isTractorBeam(Point<int> point) {
  final input = ListInput([point.x, point.y]), output = ListOutput();
  Machine(memory, input: input, output: output).run();
  return output.list.single == 1;
}

int problem1() {
  var count = 0;
  for (var x = 0; x < 50; x++) {
    for (var y = 0; y < 50; y++) {
      if (isTractorBeam(Point(x, y))) count++;
    }
  }
  return count;
}

int problem2([Point<int> size = const Point<int>(99, 99)]) {
  var upper = const Point(0, 50);
  while (true) {
    if (isTractorBeam(upper)) {
      final lower = Point(upper.x + size.x, upper.y - size.y);
      if (isTractorBeam(lower)) return 10000 * upper.x + lower.y;
      upper = Point(upper.x, upper.y + 1);
    } else {
      upper = Point(upper.x + 1, upper.y);
    }
  }
}

void main() {
  assert(problem1() == 112);
  assert(problem2() == 18261982);
}
