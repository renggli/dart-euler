/**
 * Problem 37: Truncatable primes
 *
 * The number 3797 has an interesting property. Being prime itself, it is
 * possible to continuously remove digits from left to right, and remain prime
 * at each stage: 3797, 797, 97, and 7. Similarly we can work from right to
 * left: 3797, 379, 37, and 3.
 *
 * Find the sum of the only eleven primes that are both truncatable from left
 * to right and right to left.
 *
 * NOTE: 2, 3, 5, and 7 are not considered to be truncatable primes.
 */
library problem_037;

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';
import 'package:more/range.dart';

final primes = primesUpTo(800000);
final primeSet = primes.toSet();

bool isTruncable(int prime) {
  var digits = digits(prime).toList();
  for (var i = 1; i < digits.length; i++) {
    if (!primeSet.contains(polynomial(digits.sublist(0, i)))
        || !primeSet.contains(polynomial(digits.sublist(i, digits.length)))) {
      return false;
    }
  }
  return true;
}

void main() {
  assert(primes
      .where((x) => x > 9 && isTruncable(x))
      .reduce((a, b) => a + b) == 748317);
}