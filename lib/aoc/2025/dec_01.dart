import 'dart:io';

final offsets = File('lib/aoc/2025/dec_01.txt')
    .readAsLinesSync()
    .map((line) => (line[0] == 'L' ? -1 : 1) * int.parse(line.substring(1)))
    .toList();

int problem1() {
  var pos = 50;
  var count = 0;
  for (final offset in offsets) {
    pos = (pos + offset) % 100;
    if (pos == 0) count++;
  }
  return count;
}

int problem2() {
  var pos = 50;
  var count = 0;
  for (final offset in offsets) {
    final old = pos;
    pos += offset;
    count += offset > 0
        ? (pos / 100).floor() - (old / 100).floor()
        : (old / 100).ceil() - (pos / 100).ceil();
  }
  return count;
}

void main() {
  assert(problem1() == 1195);
  assert(problem2() == 6770);
}
