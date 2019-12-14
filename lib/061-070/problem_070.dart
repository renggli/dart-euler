/// Problem 70: Totient permutation
///
/// Euler's Totient function, φ(n) [sometimes called the phi function], is used
/// to determine the number of positive numbers less than or equal to n which
/// are relatively prime to n. For example, as 1, 2, 4, 5, 7, and 8, are all
/// less than nine and relatively prime to nine, φ(9)=6.
///
/// The number 1 is considered to be relatively prime to every positive number,
/// so φ(1)=1.
///
/// Interestingly, φ(87109)=79180, and it can be seen that 87109 is a
/// permutation of 79180.
///
/// Find the value of n, 1 < n < 10^7, for which φ(n) is a permutation of n and
/// the ratio n/φ(n) produces a minimum.
library euler.problem_070;

import 'package:more/math.dart';

int phi(int n) {
  var r = 0;
  for (var k = 1; k <= n; k++) {
    if (n.gcd(k) == 1) {
      r++;
    }
  }
  return r;
}

bool isPermutation(int a, int b) {
  final ad = a.digits().toList()..sort();
  final bd = b.digits().toList()..sort();
  return ad.join() == bd.join();
}

const int max = 10000000;

void main() {
  assert(false);
  var minr = 2.0;
  var minn = 0;
  for (var n = 2; n < max; n++) {
    final p = phi(n);
    final r = n / p;
    if (r < minr && isPermutation(n, p)) {
      print('$n $p $r');
      minr = r;
      minn = n;
    }
  }
  print('$minn $minr');
}
