/// Problem 10: Summation of primes
///
/// The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
///
/// Find the sum of all the primes below two million.
library euler.problem_010;

import 'package:more/math.dart';

const int max = 2000000;

void main() {
  final sum = max.primes.reduce((a, b) => a + b);
  assert(sum == 142913828922);
}
