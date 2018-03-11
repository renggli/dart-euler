/// Problem 56: Powerful digit sum
///
/// A googol (10^100) is a massive number: one followed by one-hundred zeros;
/// 100^100 is almost unimaginably large: one followed by two-hundred zeros.
/// Despite their size, the sum of the digits in each number is only 1.
///
/// Considering natural numbers of the form, a^b, where a, b < 100, what is the
/// maximum digital sum?
library euler.problem_056;

import 'package:more/collection.dart';

void main() {
  var ms = 0;
  for (var a = BigInt.one; a < new BigInt.from(100); a += BigInt.one) {
    for (var b = 1; b < 100; b++) {
      var s = string(a.pow(b))
        .fold(0, (a, b) => a + int.parse(b));
      if (s > ms) {
        ms = s;
      }
    }
  }
  assert(ms == 972);
}
