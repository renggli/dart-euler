import 'dart:io';

import 'package:data/data.dart';

final data =
    File('lib/aoc/2023/dec_09.txt')
        .readAsLinesSync()
        .map((each) => each.split(' ').map(int.parse).toList())
        .toList();

List<int> diff(List<int> input) =>
    List.generate(input.length - 1, (i) => input[i + 1] - input[i]);

int diffLast(List<int> input) =>
    input.every((each) => each == 0) ? 0 : input.last + diffLast(diff(input));

int diffFirst(List<int> input) =>
    input.every((each) => each == 0) ? 0 : input.first - diffFirst(diff(input));

void main() {
  assert(data.map(diffLast).sum() == 1995001648);
  assert(data.map(diffFirst).sum() == 988);
}
