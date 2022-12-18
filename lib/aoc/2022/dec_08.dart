import 'dart:io';

import 'package:data/matrix.dart';
import 'package:data/type.dart';
import 'package:data/vector.dart';
import 'package:more/collection.dart';

final input = File('lib/aoc/2022/dec_08.txt').readAsLinesSync();
final matrix = Matrix.generate(DataType.int32, input.length, input[0].length,
    (row, column) => int.parse(input[row][column]),
    format: MatrixFormat.rowMajor);

bool isVisible(int r, int c) {
  final height = matrix.get(r, c);
  final up = matrix.column(c).toList().take(r);
  if (up.every((each) => each < height)) return true;
  final down = matrix.column(c).toList().skip(r + 1);
  if (down.every((each) => each < height)) return true;
  final left = matrix.row(r).toList().take(c);
  if (left.every((each) => each < height)) return true;
  final right = matrix.row(r).toList().skip(c + 1);
  if (right.every((each) => each < height)) return true;
  return false;
}

int score(int r, int c) {
  final height = matrix.get(r, c);

  var up = 0;
  for (var rr = r - 1; rr >= 0; rr--) {
    up++;
    if (matrix.get(rr, c) >= height) break;
  }

  var down = 0;
  for (var rr = r + 1; rr < matrix.rowCount; rr++) {
    down++;
    if (matrix.get(rr, c) >= height) break;
  }

  var left = 0;
  for (var cc = c - 1; cc >= 0; cc--) {
    left++;
    if (matrix.get(r, cc) >= height) break;
  }

  var right = 0;
  for (var cc = c + 1; cc < matrix.columnCount; cc++) {
    right++;
    if (matrix.get(r, cc) >= height) break;
  }

  return up * down * left * right;
}

void main() {
  assert(matrix
          .map((row, col, value) => isVisible(row, col))
          .rowMajor
          .where((each) => each)
          .length ==
      1647);

  assert(matrix.map((row, col, value) => score(row, col)).rowMajor.max() ==
      392080);
}
