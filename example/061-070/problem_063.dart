/**
 * Problem 63: Powerful digit counts
 *
 * The 5-digit number, 16807=7^5, is also a fifth power. Similarly, the 9-digit number,
 * 134217728=8^9, is a ninth power.
 *
 * How many n-digit positive integers exist which are also an n-th power?
 */
library problem_063;

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';

void main() {
  var count = 0;
  for (var a = 1; a < 25; a++) {
    for (var b = 1; b < 25; b++) {
      var len = digits(pow(a, b)).length;
      if (len == b) {
        count++;
      } else if (len > b) {
        break;
      }
    }
  }
  assert(count == 49);
}
