/// Problem 27: Quadratic primes
///
/// Euler published the remarkable quadratic formula:
///
///    n^2 + n + 41
///
/// It turns out that the formula will produce 40 primes for the consecutive
/// values n = 0 to 39. However, when n = 40, 40^2 + 40 + 41 = 40 * (40 + 1) + 41
/// is divisible by 41, and certainly when n = 41, 41^2 + 41 + 41 is clearly
/// divisible by 41.
///
/// Using computers, the incredible formula n^2 - 79n + 1601 was discovered,
/// which produces 80 primes for the consecutive values n = 0 to 79. The
/// product of the coefficients, 79 and 1601, is 126479.
///
/// Considering quadratics of the form:
///
///    n^2 + an + b, where |a| < 1000 and |b| < 1000
///
/// where |x| is the modulus/absolute value of x e.g. |11| = 11 and |4| = 4.
///
/// Find the product of the coefficients, a and b, for the quadratic expression
/// that produces the maximum number of primes for consecutive values of n,
/// starting with n = 0.
library euler.problem_027;

import 'package:more/int_math.dart';

final limit = 999;

final Set<int> primes = primesUpTo(1000000).toSet();

int consecutivePrimes(int a, int b) {
  for (var n = 0; n < 90; n++) {
    if (!primes.contains(n * n + a * n + b)) {
      return n;
    }
  }
  throw ArgumentError('Should never happen');
}

void main() {
  var mc = 0, mp = 0;
  var bs = primesUpTo(limit).takeWhile((x) => x < limit).toList();
  for (var a = -limit; a <= limit; a++) {
    for (var b in bs) {
      var c = consecutivePrimes(a, b);
      if (c > mc) {
        mc = c;
        mp = a * b;
      }
    }
  }
  assert(mp == -59231);
}
