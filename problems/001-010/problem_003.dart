/**
 * Problem 3: Largest prime factor
 *
 * The prime factors of 13195 are 5, 7, 13 and 29.
 *
 * What is the largest prime factor of the number 600851475143 ?
 */
library problem_003;

import 'dart:math';
import 'package:more/bit_set.dart';

List<int> primesUpTo(int max) {
  List<int> primes = new List();
  BitSet sieve = new BitSet(1 + max);
  for (int i = 2; i <= max; i++) {
    if (!sieve[i]) {
      for (int j = i; j <= max; j += i) {
        sieve[j] = true;
      }
      primes.add(i);
    }
  }
  return primes;
}

var value = 600851475143;

void main() {
  var max = sqrt(value).ceil();
  for (int factor in primesUpTo(max).reversed) {
    if (value % factor == 0) {
      assert(factor == 6857);
      return;
    }
  }
  assert(false);
}
