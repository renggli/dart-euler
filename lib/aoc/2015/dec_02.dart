import 'dart:io';
import 'package:data/data.dart';

final input = File('lib/aoc/2015/dec_02.txt').readAsLinesSync();

Iterable<List<int>> get boxes =>
    input.map((line) => line.split('x').map(int.parse).toList()..sort());

int part1() => boxes
    .map(
      (dims) =>
          3 * dims[0] * dims[1] + 2 * dims[1] * dims[2] + 2 * dims[2] * dims[0],
    )
    .sum();

int part2() => boxes
    .map((dims) => 2 * (dims[0] + dims[1]) + dims[0] * dims[1] * dims[2])
    .sum();

void main() {
  assert(part1() == 1586300);
  assert(part2() == 3737498);
}
