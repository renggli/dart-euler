import 'dart:convert';
import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_15.txt').readAsStringSync().split(',');

int hash(String source) => const AsciiCodec()
    .encode(source)
    .fold(0, (prev, curr) => (prev + curr) * 17 % 256);

int part1() => data.map(hash).sum();

int part2() {
  final regexp = RegExp(r'(\w+)(-|=(\d+))$');
  final boxes = List.generate(256, (index) => <String, int>{});
  for (final command in data) {
    final match = regexp.matchAsPrefix(command);
    if (match != null) {
      final label = match.group(1)!;
      final focal = match.group(3)?.also(int.parse);
      final box = boxes[hash(label)];
      if (focal == null) {
        box.remove(label);
      } else {
        box[label] = focal;
      }
    } else {
      throw StateError('Unable to parse "$command"');
    }
  }
  return boxes
      .indexed(start: 1)
      .map(
        (box) => box.value.entries
            .indexed(start: 1)
            .map((lens) => box.index * lens.index * lens.value.value)
            .sum(),
      )
      .sum();
}

void main() {
  assert(part1() == 514281);
  assert(part2() == 244199);
}
