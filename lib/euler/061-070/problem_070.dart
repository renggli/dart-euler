// Problem 70: Totient permutation
//
// Euler's Totient function, φ(n) (sometimes called the phi function), is used
// to determine the number of positive numbers less than or equal to n which
// are relatively prime to n. For example, as 1, 2, 4, 5, 7, and 8, are all
// less than nine and relatively prime to nine, φ(9)=6.
//
// The number 1 is considered to be relatively prime to every positive number,
// so φ(1)=1.
//
// Interestingly, φ(87109)=79180, and it can be seen that 87109 is a
// permutation of 79180.
//
// Find the value of n, 1 < n < 10^7, for which φ(n) is a permutation of n and
// the ratio n/φ(n) produces a minimum.

import 'package:more/math.dart';

bool isPermutation(int a, int b) {
  final counts = List.filled(10, 0);
  while (a > 0) {
    counts[a % 10]++;
    a ~/= 10;
  }
  while (b > 0) {
    counts[b % 10]--;
    b ~/= 10;
  }
  for (final c in counts) {
    if (c != 0) return false;
  }
  return true;
}

void main() {
  const max = 10000000;
  var minR = double.infinity;
  var minN = 0;

  final primes = AtkinPrimeSieve(max).primes.toList();

  for (var i = 0; i < primes.length; i++) {
    for (var j = i + 1; j < primes.length; j++) {
      final p1 = primes[i];
      final p2 = primes[j];
      final n = p1 * p2;
      if (n > max) break;

      final phi = (p1 - 1) * (p2 - 1);
      final r = n / phi;

      if (r < minR && isPermutation(n, phi)) {
        minR = r;
        minN = n;
      }
    }
  }

  assert(minN == 8319823);
}
