import 'dart:io';

import 'package:data/data.dart';

final input = File('lib/aoc/2024/dec_19.txt').readAsStringSync().split('\n\n');

final availablePattern = input[0].trim().split(', ');
final desiredPattern = input[1].trim().split('\n');

int count(String desired, {int start = 0, Map<int, int>? cache}) {
  cache ??= {};
  if (cache.containsKey(start)) {
    return cache[start]!;
  }
  if (start == desired.length) {
    return cache[start] = 1;
  }
  return cache[start] = availablePattern
      .where((available) => desired.startsWith(available, start))
      .map(
        (available) =>
            count(desired, start: start + available.length, cache: cache),
      )
      .sum();
}

int part1() => desiredPattern.where((desired) => count(desired) > 0).length;

int part2() => desiredPattern.map(count).sum();

void main() {
  assert(part1() == 296);
  assert(part2() == 619970556776002);
}
