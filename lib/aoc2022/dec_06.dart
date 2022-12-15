import 'dart:io';

import 'package:collection/collection.dart';

final stream =
    File('lib/aoc2022/dec_06.txt').readAsStringSync().split('').toList();

int firstDistinctIndex(int count) {
  var queue = QueueList<String>(count);
  for (var i = 0; i < stream.length; i++) {
    final value = stream[i];
    if (queue.length == count && queue.toSet().length == count) {
      return i;
    }
    while (count <= queue.length) {
      queue.removeFirst();
    }
    queue.add(value);
  }
  return -1;
}

void main() {
  assert(firstDistinctIndex(4) == 1356);
  assert(firstDistinctIndex(14) == 2564);
}
