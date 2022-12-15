/// Problem 41: Pandigital prime
///
/// We shall say that an n-digit number is pandigital if it makes use of all
/// digits 1 to n exatly once. For example, 2143 is a 4-digit pandigital and is
/// also a prime.
///
/// What is the largest n-digit pandigital prime that exists?
import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/math.dart';

const max = 7654321;
final primes = EratosthenesPrimeSieve(sqrt(max).ceil()).primes.toList();

bool isPrime(int value) {
  for (final prime in primes) {
    if (value % prime == 0) {
      return false;
    }
  }
  return true;
}

bool isPandigital(int x) {
  final decimals = x.digits().toList();
  for (var n = 1; n <= decimals.length; n++) {
    if (!decimals.contains(n)) {
      return false;
    }
  }
  return true;
}

void main() {
  assert(max
          .to(0, step: -1)
          .where((value) => isPrime(value) && isPandigital(value))
          .first ==
      7652413);
}
