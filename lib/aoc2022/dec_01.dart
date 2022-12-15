import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/iterable.dart';

final caloriesPerElf = File('lib/aoc2022/dec_01.txt')
    .readAsStringSync()
    .split('\n\n')
    .map((elf) => elf.split('\n').map(int.parse))
    .map((caloriesPerElf) => caloriesPerElf.sum());

void main() {
  assert(caloriesPerElf.max() == 72240);
  assert(caloriesPerElf.largest(3).sum() == 210957);
}
