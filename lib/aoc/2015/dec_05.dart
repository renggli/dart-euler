import 'dart:io';

import 'package:more/more.dart';

final exampleInput1 = [
  'ugknbfddgicrmopn',
  'aaa',
  'jchzalrnumimnmhp',
  'haegwjzuvuyypxyu',
  'dvszwmarrgswjxmb',
];
final exampleInput2 = [
  'qjhvhtzxzqqjkmpb',
  'xxyxx',
  'uurcxstgmygtbstg',
  'ieodomkazucvgmuy',
];
final puzzleInput = File('lib/aoc/2015/dec_05.txt').readAsLinesSync();

bool isNice1(String s) =>
    RegExp(r'[aeiou]').allMatches(s).length >= 3 &&
    RegExp(r'(.)\1').hasMatch(s) &&
    !RegExp(r'ab|cd|pq|xy').hasMatch(s);

int part1(List<String> data) => data.count(isNice1);

bool isNice2(String s) =>
    RegExp(r'(..).*\1').hasMatch(s) && RegExp(r'(.).\1').hasMatch(s);

int part2(List<String> data) => data.count(isNice2);

void main() {
  assert(part1(exampleInput1) == 2);
  assert(part1(puzzleInput) == 255);
  assert(part2(exampleInput2) == 2);
  assert(part2(puzzleInput) == 55);
}
