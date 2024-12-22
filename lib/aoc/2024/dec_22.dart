import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final input =
    File('lib/aoc/2024/dec_22.txt').readAsLinesSync().map(int.parse).toList();

int next(int value) {
  final step1 = (value ^ value * 64) % 16777216;
  final step2 = (step1 ^ step1 ~/ 32) % 16777216;
  return (step2 ^ step2 * 2048) % 16777216;
}

Iterable<int> generate(int secret) sync* {
  while (true) {
    yield secret;
    secret = next(secret);
  }
}

int problem1() => input.map((each) => generate(each).elementAt(2000)).sum();

int problem2() {
  final sequenceValues = Multiset<String>();
  for (final start in input) {
    final sequences = <String>{};
    for (final (key, count) in generate(start)
        .take(2000)
        .pairwise()
        .map((pair) => (pair.last, pair.last % 10 - pair.first % 10))
        .window(4)
        .map((seq) =>
            (seq.map((each) => each.last).join('*'), seq.last.first % 10))) {
      if (sequences.add(key)) {
        sequenceValues.add(key, count);
      }
    }
  }
  return sequenceValues.elementCounts.max();
}

void main() {
  assert(problem1() == 17960270302);
  assert(problem2() == 2042);
}
