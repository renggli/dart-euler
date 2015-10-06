/// Problem 14: Longest Collatz sequence
///
/// The following iterative sequence is defined for the set of positive
/// integers:
///
///     n -> n / 2 (n is even)
///     n -> 3 * n + 1 (n is odd)
///
/// Using the rule above and starting with 13, we generate the following
/// sequence:
///
///     13  40  20  10  5  16  8  4  2  1
///
/// It can be seen that this sequence (starting at 13 and finishing at 1)
/// contains 10 terms. Although it has not been proved yet (Collatz Problem), it
/// is thought that all starting numbers finish at 1.
///
/// Which starting number, under one million, produces the longest chain?
///
/// NOTE: Once the chain starts the terms are allowed to go above one million.
library problem_014;

import 'dart:typed_data';

final max = 1000000;

final cache = new Uint16List(4 * max);

int collatz(int value) {
  if (value < cache.length && cache[value] > 0) {
    return cache[value];
  }
  var result = value.isEven
      ? 1 + collatz(value ~/ 2)
      : value != 1
          ? 1 + collatz(3 * value + 1)
          : value;
  if (value < cache.length) {
    cache[value] = result;
  }
  return result;
}

void main() {
  var i_m = 0, c_m = 0;
  for (int i = 1; i < max; i++) {
    if (collatz(i) > c_m) {
      i_m = i;
      c_m = collatz(i);
    }
  }
  assert(i_m == 837799);
}
