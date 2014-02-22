/**
 * Problem 56: Powerful digit sum
 *
 * A googol (10^100) is a massive number: one followed by one-hundred zeros;
 * 100^100 is almost unimaginably large: one followed by two-hundred zeros.
 * Despite their size, the sum of the digits in each number is only 1.
 *
 * Considering natural numbers of the form, a^b, where a, b < 100, what is the
 * maximum digital sum?
 */
library problem_056;

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';

void main() {
  var ms = 0;
  for (var a = 1; a < 100; a++) {
    for (var b = 1; b < 100; b++) {
      var s = digits(pow(a, b))
        .reduce((a, b) => a + b);
      if (s > ms) {
        ms = s;
      }
    }
  }
  assert(ms == 972);
}
