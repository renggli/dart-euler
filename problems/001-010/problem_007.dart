/**
 * Problem 7: 10001st prime
 *
 * By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see
 * that the 6th prime is 13.
 *
 * What is the 10001st prime number?
 */
library problem_007;

import 'package:more/int_math.dart';

final ith = 10001;

void main() {
  assert(primesUpTo(1000000)[ith - 1] == 104743);
}
