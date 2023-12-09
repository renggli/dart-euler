import 'dart:io';

import 'package:data/data.dart';

final data = File('lib/aoc/2023/dec_09.txt')
    .readAsLinesSync()
    .map((each) => each.split(' ').map(int.parse).toList())
    .toList();

List<int> expandLast(List<int> input) {
  if (input.every((each) => each == 0)) {
    return [...input, 0];
  } else {
    final differential =
        List.generate(input.length - 1, (i) => input[i + 1] - input[i]);
    final parent = expandLast(differential);
    return [...input, input.last + parent.last];
  }
}

int problem1() => data.map((each) => expandLast(each).last).sum();

List<int> expandFirst(List<int> input) {
  if (input.every((each) => each == 0)) {
    return [0, ...input];
  } else {
    final differential =
        List.generate(input.length - 1, (i) => input[i + 1] - input[i]);
    final parent = expandFirst(differential);
    return [input.first - parent.first, ...input];
  }
}

int problem2() => data.map((each) => expandFirst(each).first).sum();

void main() {
  assert(problem1() == 1995001648);
  assert(problem2() == 988);
}
