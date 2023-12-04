import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';

final cardSplitter = RegExp(r'(:\s+|\s+[|]\s+)');
final numberSplitter = RegExp(r'\s+');

final cardMatches = File('lib/aoc/2023/dec_04.txt')
    .readAsLinesSync()
    .map((line) => line.split(cardSplitter))
    .map((tuple) => tuple[1].split(numberSplitter).map(int.parse).toSet()
        .intersection(tuple[2].split(numberSplitter).map(int.parse).toSet())
        .length)
    .toList();

void main() {
  assert(cardMatches
          .map((each) => each > 0 ? pow(2, each - 1).toInt() : each)
          .sum() ==
      19855);

  final instances = List.filled(cardMatches.length, 1);
  for (var i = 0; i < cardMatches.length; i++) {
    for (var j = i + 1; j <= i + cardMatches[i]; j++) {
      instances[j] += instances[i];
    }
  }
  assert(instances.sum() == 10378710);
}
