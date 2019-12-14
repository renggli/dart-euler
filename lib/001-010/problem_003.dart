/// Problem 3: Largest prime factor
///
/// The prime factors of 13195 are 5, 7, 13 and 29.
///
/// What is the largest prime factor of the number 600851475143 ?
library euler.problem_003;

import 'package:more/math.dart';

const int value = 600851475143;

void main() {
  final factor =
      value.sqrt().ceil().primes.lastWhere((each) => value % each == 0);
  assert(factor == 6857);
}
