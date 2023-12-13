import 'dart:io';

import 'package:data/data.dart';

final patterns = File('lib/aoc/2023/dec_13.txt')
    .readAsStringSync()
    .split('\n\n')
    .map((block) => block.split('\n'))
    .map((rows) => Matrix.fromPackedRows(DataType.string, rows.length,
        rows[0].length, rows.expand((line) => line.split('')).toList()))
    .toList();

int compare(Vector<String> a, Vector<String> b) {
  assert(a.count == b.count);
  var result = 0;
  for (var i = 0; i < a.count; i++) {
    if (a[i] != b[i]) result++;
  }
  return result;
}

int horizontalReflection(Matrix<String> pattern, {int smudge = 0}) {
  for (var i = 1; i < pattern.rowCount; i++) {
    var d = 0, lo = i - 1, hi = i;
    while (d <= smudge && 0 <= lo && hi < pattern.rowCount) {
      d += compare(pattern[lo], pattern[hi]);
      lo--;
      hi++;
    }
    if (d == smudge && (lo == -1 || hi == pattern.rowCount)) return i;
  }
  return 0;
}

int verticalReflection(Matrix<String> pattern, {int smudge = 0}) =>
    horizontalReflection(pattern.transposed, smudge: smudge);

int summary({int smudge = 0}) => patterns
    .map((pattern) =>
        100 * horizontalReflection(pattern, smudge: smudge) +
        verticalReflection(pattern, smudge: smudge))
    .sum();

int problem1() => summary();

int problem2() => summary(smudge: 1);

void main() {
  assert(problem1() == 27742);
  assert(problem2() == 32728);
}
