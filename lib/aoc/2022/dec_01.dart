import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/collection.dart';

final caloriesPerElf = File('lib/aoc/2022/dec_01.txt')
    .readAsStringSync()
    .split('\n\n')
    .map((elf) => elf.split('\n').map(int.parse))
    .map((caloriesPerElf) => caloriesPerElf.sum());

void main() {
  assert(caloriesPerElf.max() == 72240);
  assert(caloriesPerElf.largest(3).sum() == 210957);
}
