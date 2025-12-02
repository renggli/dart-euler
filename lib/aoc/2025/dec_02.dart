import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final ranges = File('lib/aoc/2025/dec_02.txt')
    .readAsStringSync()
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

int problem1() => computeSum(ranges, isInvalid1);

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

int problem2() => computeSum(ranges, isInvalid2);

void main() {
  assert(problem1() == 55916882972);
  assert(problem2() == 76169125915);
}
