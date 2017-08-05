/// Problem 70: Totient permutation
///
/// Euler's Totient function, φ(n) [sometimes called the phi function], is used to determine the
/// number of positive numbers less than or equal to n which are relatively prime to n. For example,
/// as 1, 2, 4, 5, 7, and 8, are all less than nine and relatively prime to nine, φ(9)=6.
///
/// The number 1 is considered to be relatively prime to every positive number, so φ(1)=1.
///
/// Interestingly, φ(87109)=79180, and it can be seen that 87109 is a permutation of 79180.
///
/// Find the value of n, 1 < n < 10^7, for which φ(n) is a permutation of n and the ratio n/φ(n)
/// produces a minimum.
library problem_070;

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';
import 'package:more/ordering.dart';

int phi(int n) {
  var r = 0;
  for (var k = 1; k <= n; k++) {
    if (gcd(n, k) == 1) {
      r++;
    }
  }
  return r;
}

final Ordering<int> ordering = new Ordering.natural();
final Ordering<Iterable<int>> listOrdering = ordering.lexicographical();

bool isPermutation(int a, int b) {
  var ad = digits(a).toList()..sort();
  var bd = digits(b).toList()..sort();
  return listOrdering.compare(ad, bd) == 0;
}

final max = 10e7;

void main() {
  assert(false);
  for (var n = 2; n < max; n++) {
    var p = phi(n);
    if (isPermutation(n, p)) {
      print('$n      ${p}      ${n/p}');
    }
  }
}
