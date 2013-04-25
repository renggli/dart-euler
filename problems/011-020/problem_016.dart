/**
 * Problem 16: Power digit sum
 *
 * 2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
 *
 * What is the sum of the digits of the number 2^1000?
 */
library problem_016;

import 'package:more/int_math.dart';

var exp = 1000;

void main() {
  var sum = power(2, exp)
      .toString()
      .runes
      .map((each) => each - '0'.runes.first)
      .reduce((a, b) => a + b);
  assert(sum == 1366);
}
