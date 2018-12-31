/// Problem 35: Circular primes
///
/// The number, 197, is called a circular prime because all rotations of the
/// digits: 197, 971, and 719, are themselves prime.
///
/// There are thirteen such primes below 100: 2, 3, 5, 7, 11, 13, 17, 31, 37,
/// 71, 73, 79, and 97.
///
/// How many circular primes are there below one million?
library euler.problem_035;

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';

const int max = 1000000;
final Set<int> primes = primesUpTo(max).toSet();

bool isCircular(int prime) {
  final rotation = digits(prime).toList();
  for (var round = 1; round < rotation.length; round++) {
    rotation.insert(0, rotation.removeLast());
    if (!primes.contains(polynomial(rotation))) {
      return false;
    }
  }
  return true;
}

void main() {
  assert(primes.where(isCircular).length == 55);
}
