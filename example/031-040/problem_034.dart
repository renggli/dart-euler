/**
 * Problem 34: Digit factorials
 *
 * 145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.
 *
 * Find the sum of all numbers which are equal to the sum of the factorial of
 * their digits.
 *
 * Note: as 1! = 1 and 2! = 2 are not sums they are not included.
 */
library problem_034;

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';

void main() {
  var t = 0, m = 100000;
  for (var i = 3; i <= m; i++) {
    var s = digits(i)
        .map(factorial)
        .reduce((a, b) => a + b);
    if (i == s) {
      t += s;
    }
  }
  assert(t == 40730);
}