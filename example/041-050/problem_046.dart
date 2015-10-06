/// Problem 46: Goldbach's other conjecture
///
/// It was proposed by Christian Goldbach that every odd composite number can
/// be written as the sum of a prime and twice a square.
///
/// 9 = 7 + 2 * 1^2
/// 15 = 7 + 2 * 2^2
/// 21 = 3 + 2 * 3^2
/// 25 = 7 + 2 * 3^2
/// 27 = 19 + 2 * 2^2
/// 33 = 31 + 2 * 1^2
///
/// It turns out that the conjecture was false.
///
/// What is the smallest odd composite that cannot be written as the sum of a
/// prime and twice a square?
library problem_046;

import 'dart:math';
import 'package:more/int_math.dart';

final primes = primesUpTo(10000);
final prime_set = primes.toSet();

bool verifySquare(int n) {
  if (n.isOdd) {
    return false;
  }
  var m = n ~/ 2;
  var s = sqrt(m).truncate();
  return s * s == m;
}

bool verify(int n) {
  return primes
      .takeWhile((p) => p <= n - 2)
      .any((p) => verifySquare(n - p));
}

void main() {
  for (var n = 3; ; n += 2) {
    if (!prime_set.contains(n) && !verify(n)) {
      assert(n == 5777);
      return;
    }
  }
}
