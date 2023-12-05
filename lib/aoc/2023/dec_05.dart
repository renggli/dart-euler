import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_05.txt')
    .readAsStringSync()
    .split('\n\n')
    .map((block) =>
        block.skipTo(':').trim().split(RegExp(r'\s+')).map(int.parse).toList())
    .toList();
final initialSeeds = data[0];
final mappings =
    data.skip(1).map((block) => block.chunked(3).toList()).toList();

void transform(List<int> seeds, List<List<int>> ranges) {
  for (var i = 0; i < seeds.length; i++) {
    for (final range in ranges) {
      if (seeds[i].between(range[1], range[1] + range[2])) {
        seeds[i] += range[0] - range[1];
        break;
      }
    }
  }
}

int problem1() {
  final seeds = Uint32List.fromList(initialSeeds);
  for (final mapping in mappings) {
    transform(seeds, mapping);
  }
  return seeds.min;
}

int problem2() {
  final mins = <int>[];
  for (final range in initialSeeds.chunked(2)) {
    final seeds = Uint32List(range[1]);
    for (var i = 0; i < seeds.length; i++) {
      seeds[i] = range[0] + i;
    }
    for (final mapping in mappings) {
      transform(seeds, mapping);
    }
    mins.add(seeds.min);
  }
  return mins.min;
}

void main() {
  assert(problem1() == 910845529);
  assert(problem2() == 77435348);
}
