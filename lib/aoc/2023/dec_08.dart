import 'dart:io';

import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_08.txt').readAsStringSync().split('\n\n');
final instructions = data[0].split('');
final network = data[1]
    .split('\n')
    .map((line) => line.split(RegExp(r'[ =(,)]+')))
    .toMap<String, List<String>>(
      key: (parts) => parts[0],
      value: (parts) => parts.sublist(1, 3),
    );

int cycleLength(String start, bool Function(String) end) {
  var count = 1;
  var current = start;
  for (final instruction in instructions.repeat()) {
    current = network[current]![instruction == 'L' ? 0 : 1];
    if (end(current)) break;
    count++;
  }
  return count;
}

int part1() => cycleLength('AAA', (each) => each == 'ZZZ');

int part2() => network.keys
    .where((each) => each.endsWith('A'))
    .map((each) => cycleLength(each, (each) => each.endsWith('Z')))
    .lcm();

void main() {
  assert(part1() == 12169);
  assert(part2() == 12030780859469);
}
