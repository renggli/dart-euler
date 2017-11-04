/// Problem 37: Truncatable primes
///
/// The number 3797 has an interesting property. Being prime itself, it is
/// possible to continuously remove digits from left to right, and remain prime
/// at each stage: 3797, 797, 97, and 7. Similarly we can work from right to
/// left: 3797, 379, 37, and 3.
///
/// Find the sum of the only eleven primes that are both truncatable from left
/// to right and right to left.
///
/// NOTE: 2, 3, 5, and 7 are not considered to be truncatable primes.
library euler.problem_037;

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';

final List<int> primes = primesUpTo(800000);
final Set<int> primeSet = primes.toSet();

bool isTruncable(int prime) {
  var expanded = digits(prime).toList();
  for (var i = 1; i < expanded.length; i++) {
    if (!primeSet.contains(polynomial(expanded.sublist(0, i)))
        || !primeSet.contains(polynomial(expanded.sublist(i, expanded.length)))) {
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
