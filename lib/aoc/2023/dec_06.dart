import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_06.txt')
    .readAsLinesSync()
    .map((line) => line.skipTo(RegExp(r':\s+')))
    .toList();

int getWins(int time, int distance) =>
    IntegerRange(time).count((held) => held * (time - held) > distance);

int problem1() {
  final times = data[0].split(RegExp(r'\s+')).map(int.parse);
  final distances = data[1].split(RegExp(r'\s+')).map(int.parse);
  final result = <int>[];
  for (final [time, distance] in [times, distances].zip()) {
    result.add(getWins(time, distance));
  }
  return result.product();
}

int problem2() {
  final time = int.parse(data[0].replaceAll(' ', ''));
  final distance = int.parse(data[1].replaceAll(' ', ''));
  return getWins(time, distance);
}

void main() {
  assert(problem1() == 4811940);
  assert(problem2() == 30077773);
}
