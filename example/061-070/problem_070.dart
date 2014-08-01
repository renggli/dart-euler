/**
 * Problem 70: Totient permutation
 *
 * Euler's Totient function, φ(n) [sometimes called the phi function], is used to determine the
 * number of positive numbers less than or equal to n which are relatively prime to n. For example,
 * as 1, 2, 4, 5, 7, and 8, are all less than nine and relatively prime to nine, φ(9)=6.
 *
 * The number 1 is considered to be relatively prime to every positive number, so φ(1)=1.
 *
 * Interestingly, φ(87109)=79180, and it can be seen that 87109 is a permutation of 79180.
 *
 * Find the value of n, 1 < n < 10^7, for which φ(n) is a permutation of n and the ratio n/φ(n)
 * produces a minimum.
 */
library problem_070;

import 'dart:math';

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';

int phi(int n) {
  var count = 0;
  for (var i = 1; i < n; i++) {
    if (gcd(n, i) == 1) {
      count++;
    }
  }
  return count;
}

bool isPermutation(int as, int bs) {
  var remaining = new List.from(digits(as));
  for (var b in digits(bs)) {
    var index = remaining.indexOf(b);
    if (index < 0) {
      return false;
    }
    remaining.removeAt(index);
  }
  return remaining.isEmpty;
}

var target = 10000000;

void main() {
  var p = sqrt(target).floor();
  var q = sqrt(target).ceil();

  while (true) {
    while (!isProbablyPrime(p)) p--;
    while (!isProbablyPrime(q)) q++;

    print(p);
    print(q);

    var f1 = p * q;
    var f2 = phi(f1);

    print(f1);
    print(f2);

    print(f1 / f2);
    print(isPermutation(f1, f2));

    p--;
    q++;

    print('---');
  }

//  for (var n = 10000000 - 1; n > 0; n--) {
//    if (isProbablyPrime(n)) {
//      var f = n - 1;
//      if (isPermutation(n, f)) {
//        print('$n - $f - ${n / f}');
//      }
//    }
//  }
}
