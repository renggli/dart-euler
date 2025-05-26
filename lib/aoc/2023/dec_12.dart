import 'dart:io';

import 'package:data/data.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_12.txt').readAsLinesSync().map(
  (line) => (
    springs: line.takeTo(' ').split(''),
    damaged: line.skipTo(' ').split(',').map(int.parse).toList(),
  ),
);

int arrangements(
  List<String> springs,
  List<int> damaged, [
  int s = 0,
  int d = 0,
  int l = 0,
  Map<(int, int, int), int>? cache,
]) {
  // Check if we already computed the arrangement count at this position.
  final cacheKey = (s, d, l), cacheMap = cache ?? {};
  if (cacheMap.containsKey(cacheKey)) return cacheMap[cacheKey]!;
  // Count the remaining combinations:
  // - `s` is the current position in `springs`.
  // - `d` is the current position in `damaged`.
  // - `l` is the current length of `damaged` in `springs`.
  var count = 0;
  if (springs.length == s) {
    // Check if we have found a solution.
    if ((damaged.length == d && l == 0) ||
        (damaged.length - 1 == d && damaged[d] == l)) {
      count++;
    }
  } else {
    if (springs[s] == '.' || springs[s] == '?') {
      if (l == 0) {
        // Count the next spring.
        count += arrangements(springs, damaged, s + 1, d, 0, cacheMap);
      } else if (d < damaged.length && damaged[d] == l) {
        // Count the next non-damaged spring.
        count += arrangements(springs, damaged, s + 1, d + 1, 0, cacheMap);
      }
    }
    if (springs[s] == '#' || springs[s] == '?') {
      // Count the next damaged spring.
      count += arrangements(springs, damaged, s + 1, d, l + 1, cacheMap);
    }
  }
  // Remember the counted number of arrangements.
  return cacheMap[cacheKey] = count;
}

int problem1() =>
    data.map((each) => arrangements(each.springs, each.damaged)).sum();

int problem2() => data
    .map(
      (each) => arrangements(
        repeat(
          each.springs,
          count: 5,
        ).separatedBy(() => ['?']).flatten().toList(),
        each.damaged.repeat(count: 5).toList(),
      ),
    )
    .sum();

void main() {
  assert(problem1() == 7670);
  assert(problem2() == 157383940585037);
}
