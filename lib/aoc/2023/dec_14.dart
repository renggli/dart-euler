import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_14.txt').readAsLinesSync().also((rows) =>
    Matrix.fromPackedRows(DataType.string, rows.length, rows[0].length,
        rows.expand((line) => line.split('')).toList()));

void tilt(Matrix<String> matrix) {
  for (var r = 1; r < matrix.rowCount; r++) {
    for (var c = 0; c < matrix.colCount; c++) {
      if (matrix.get(r, c) == 'O') {
        var t = r;
        while (0 < t && matrix.get(t - 1, c) == '.') {
          t--;
        }
        if (t < r) {
          matrix.set(r, c, '.');
          matrix.set(t, c, 'O');
        }
      }
    }
  }
}

int computeLoad(Matrix<String> matrix) {
  var result = 0;
  for (var r = 0; r < matrix.rowCount; r++) {
    for (var c = 0; c < matrix.colCount; c++) {
      if (matrix.get(r, c) == 'O') {
        result += matrix.rowCount - r;
      }
    }
  }
  return result;
}

int problem1() {
  final matrix = data.toMatrix();
  tilt(matrix);
  return computeLoad(matrix);
}

int problem2({int cycles = 1000000000}) {
  final matrix = data.toMatrix();
  final seen = <String, int>{};
  for (var i = 0; i < cycles; i++) {
    tilt(matrix); // north
    tilt(matrix.rotated(count: 1)); // west
    tilt(matrix.rotated(count: 2)); // south
    tilt(matrix.rotated(count: 3)); // east
    final string = matrix.rowMajor.map((cell) => cell.value).join('');
    final last = seen[string];
    if (last != null) {
      // Jump to the last cycle
      i += (cycles - i) ~/ (i - last) * (i - last);
    }
    seen[string] = i;
  }
  return computeLoad(matrix);
}

void main() {
  assert(problem1() == 113486);
  assert(problem2() == 104409);
}
