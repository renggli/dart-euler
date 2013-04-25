/**
 * Problem 7: 10001st prime
 *
 * By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see
 * that the 6th prime is 13.
 *
 * What is the 10001st prime number?
 */
library problem_007;

import 'problem_003.dart' as problem_003;

var ith = 10001;

void main() {
  assert(problem_003.primesUpTo(1000000)[ith - 1] == 104743);
}
