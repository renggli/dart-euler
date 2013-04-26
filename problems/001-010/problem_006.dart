/**
 * Problem 6: Sum square difference
 *
 * The sum of the squares of the first ten natural numbers is,
 *
 *   1^2 + 2^2 + ... + 10^2 = 385
 *
 * The square of the sum of the first ten natural numbers is,
 *
 *   (1 + 2 + ... + 10)^2 = 55^2 = 3025
 *
 * Hence the difference between the sum of the squares of the first ten natural
 * numbers and the square of the sum is 3025 - 385 = 2640.
 *
 * Find the difference between the sum of the squares of the first one hundred
 * natural numbers and the square of the sum.
 */
library problem_006;

import 'package:more/range.dart';

num sum(int start, int stop, num fun(int)) {
  return range(start, stop + 1)
      .map(fun)
      .reduce((a, b) => a + b);
}

var max = 100;

void main() {
  var sum_of_squares = sum(1, max, (i) => i * i);
  var square_of_sums = sum(1, max, (i) => i) * sum(1, max, (i) => i);
  var total = square_of_sums - sum_of_squares;
  assert(total == 25164150);
}
