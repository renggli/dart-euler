import 'dart:io';
import 'dart:math';

import 'package:data/data.dart';
import 'package:more/more.dart';

final input = File('lib/aoc/2024/dec_21.txt').readAsLinesSync();

final directions = {
  const Point(-1, 0): '^',
  const Point(0, 1): '>',
  const Point(1, 0): 'v',
  const Point(0, -1): '<',
};

final numericKeypad = Matrix.fromRows(DataType.string, [
  ['7', '8', '9'],
  ['4', '5', '6'],
  ['1', '2', '3'],
  [' ', '0', 'A'],
]);
final directionalKeypad = Matrix.fromRows(DataType.string, [
  [' ', '^', 'A'],
  ['<', 'v', '>'],
]);

Point<int> findPosition(Matrix<String> keypad, String key) => keypad.rowMajor
    .where((cell) => cell.value == key)
    .map((cell) => Point(cell.row, cell.col))
    .single;

Iterable<String> findPaths(
  Matrix<String> keypad,
  String source,
  String target,
) =>
    dijkstraSearch(
          startVertices: [findPosition(keypad, source)],
          targetPredicate: (each) => keypad.get(each.x, each.y) == target,
          successorsOf: (each) => directions.keys
              .map((offset) => each + offset)
              .where(
                (each) =>
                    keypad.isWithinBounds(each.x, each.y) &&
                    keypad.get(each.x, each.y) != ' ',
              ),
          includeAlternativePaths: true,
        )
        .map(
          (path) => path.edges
              .map((edge) => directions[edge.target - edge.source]!)
              .join(),
        )
        .map((path) => '${path}A');

final cache = <String, int>{};

int findLength(String code, int max, [int depth = 0]) {
  final cacheKey = '$code*$max*$depth';
  if (cache.containsKey(cacheKey)) return cache[cacheKey]!;
  var length = 0;
  var previous = 'A';
  final keypad = depth == 0 ? numericKeypad : directionalKeypad;
  for (final current in code.toList()) {
    final paths = findPaths(keypad, previous, current);
    if (depth == max) {
      length += paths.map((path) => path.length).min();
    } else {
      length += paths.map((path) => findLength(path, max, depth + 1)).min();
    }
    previous = current;
  }
  cache[cacheKey] = length;
  return length;
}

int run(String code, int depth) =>
    int.parse(const CharMatcher.digit().retainFrom(code)) *
    findLength(code, depth);

int problem1() => input.map((code) => run(code, 2)).sum();

int problem2() => input.map((code) => run(code, 25)).sum();

void main() {
  assert(problem1() == 164960);
  assert(problem2() == 205620604017764);
}
