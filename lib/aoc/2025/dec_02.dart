import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

import '../../tools.dart';

const example =
    '11-22,95-115,998-1012,1188511880-1188511890,222220-222224,'
    '1698522-1698528,446443-446449,38593856-38593862,565653-565659,'
    '824824821-824824827,2121212118-2121212124';

List<Range<int>> parseRanges(String input) => input
    .split(',')
    .map((range) => range.split('-').map(int.parse))
    .map((values) => values.first.to(values.last + 1))
    .toList();

int computeSum(Iterable<Iterable<int>> ranges, Predicate1<int> predicate) =>
    ranges.expand((range) => range).where(predicate).sum();

bool isInvalid1(int id) {
  final str = id.toString();
  if (str.length.isOdd) return false;
  final mid = str.length ~/ 2;
  return str.substring(0, mid) == str.substring(mid);
}

@AoC(
  year: 2025,
  day: 2,
  part: 1,
  expected: 55916882972,
  examples: [Example(example, expected: 1227775554)],
)
int part1(String input) => computeSum(parseRanges(input), isInvalid1);

bool isInvalid2(int id) {
  final str = id.toString();
  for (var len = 1; len <= str.length ~/ 2; len++) {
    if (str.length % len == 0) {
      final pattern = str.substring(0, len);
      if (str == pattern * (str.length ~/ len)) {
        return true;
      }
    }
  }
  return false;
}

@AoC(
  year: 2025,
  day: 2,
  part: 2,
  expected: 76169125915,
  examples: [Example(example, expected: 4174379265)],
)
int part2(String input) => computeSum(parseRanges(input), isInvalid2);

void main() => run();
