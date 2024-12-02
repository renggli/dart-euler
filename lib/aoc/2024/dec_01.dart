import 'dart:io';
import 'package:data/data.dart';
import 'package:more/more.dart';

final whitespace = RegExp(r'\s+');
final input = File('lib/aoc/2024/dec_01.txt')
    .readAsLinesSync()
    .map((values) => values.split(whitespace).map(int.parse))
    .zip()
    .map((list) => list.toSortedList())
    .toList();

int problem1() =>
    input.zip().map((values) => (values[0] - values[1]).abs()).sum();

int problem2() =>
    input[0].map((each) => each * input[1].occurrences(each)).sum();

void main() {
  assert(problem1() == 765748);
  assert(problem2() == 27732508);
}
