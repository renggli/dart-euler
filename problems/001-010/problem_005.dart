/**
 * Problem 5: Smallest multiple
 *
 * 2520 is the smallest number that can be divided by each of the numbers
 * from 1 to 10 without any remainder.
 *
 * What is the smallest positive number that is evenly divisible by all of the
 * numbers from 1 to 20?
 */
library problem_005;

import 'package:more/int_math.dart';

var min = 1;
var max = 20;

void main() {
  var result = 1;
  for (int i = min; i <= max; i++) {
    result = lcm(result, i);
  }
  assert(result == 232792560);
}
