import 'dart:convert';
import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_15.txt').readAsStringSync().split(',');

int hash(String source) =>
    const AsciiCodec().encode(source).fold(0, (prev, each) {
      var result = prev + each;
      result *= 17;
      return result % 256;
    });

int problem1() => data.map(hash).sum();

int problem2() {
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
  var power = 0;
  for (final box in boxes.indexed(start: 1)) {
    for (final lens in box.value.entries.indexed(start: 1)) {
      power += box.index * lens.index * lens.value.value;
    }
  }
  return power;
}

void main() {
  assert(problem1() == 514281);
  assert(problem2() == 244199);
}
