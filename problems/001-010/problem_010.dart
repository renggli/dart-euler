/**
 * Problem 10: Summation of primes
 *
 * The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
 *
 * Find the sum of all the primes below two million.
 */
library problem_010;

import 'package:more/int_math.dart';

var max = 2000000;

void main() {
  var sum = primesUpTo(max).reduce((a, b) => a + b);
  assert(sum == 142913828922);
}
