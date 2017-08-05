/// Problem 41: Pandigital prime
///
/// We shall say that an n-digit number is pandigital if it makes use of all
/// digits 1 to n exatly once. For example, 2143 is a 4-digit pandigital and is
/// also a prime.
///
/// What is the largest n-digit pandigital prime that exists?
library problem_041;

import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/int_math.dart';
import 'package:more/iterable.dart';

final max = 7654321;
final primes = primesUpTo(sqrt(max).ceil());

bool isPrime(int value) {
  for (var prime in primes) {
    if (value % prime == 0) {
      return false;
    }
  }
  return true;
}

bool isPandigital(int x) {
  var decimals = digits(x).toList();
  for (var n = 1; n <= decimals.length; n++) {
    if (!decimals.contains(n)) {
      return false;
    }
  }
  return true;
}

void main() {
  assert(range(max, 0, -1)
      .where((value) => isPrime(value) && isPandigital(value))
      .first == 7652413);
}
