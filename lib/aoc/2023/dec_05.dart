import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_05.txt')
    .readAsStringSync()
    .split('\n\n')
    .toMap(
    key: (block) => block.takeTo(':'),
    value: (block) =>
        block
            .skipTo(':')
            .trim()
            .split(RegExp(r'\s+'))
            .map(int.parse)
            .toList());

List<int> transform(List<int> seeds, List<int> mapping) =>
    seeds.map((each) {
      for (var i = 0; i < mapping.length; i += 3) {
        if (each.between(mapping[i + 1], mapping[i + 1] + mapping[i + 2])) {
          return each - mapping[i + 1] + mapping[i];
        }
      }
      return each;
    }).toList();


void main() {
  // var seeds = [...data['seeds']!];
  //
  // for (final MapEntry(:key, :value) in data.entries) {
  //   if (key != 'seeds') {
  //     seeds = transform(seeds, value);
  //   }
  // }
  // print(seeds.min() == 910845529);

  final seeds = [...data['seeds']!];
  final mins = <int>[];
  for (var i = 0; i < seeds.length; i += 2) {
    var part = List.generate(seeds[i+1], (index) => seeds[i] + index);
    for (final MapEntry(:key, :value) in data.entries) {
      if (key != 'seeds') {
        part = transform(part, value);
      }
    }
    mins.add(part.min());
  }
  print(mins.min());

  // print(ranges);
  // for (final MapEntry(:key, :value) in data.entries) {
  //   if (key != 'seeds') {
  //
  //
  //     print(seeds2.length);
  //     seeds2 = transform(seeds2, value);
  //   }
  // }
  // print(seeds2.min());
}
