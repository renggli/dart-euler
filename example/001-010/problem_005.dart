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
import 'package:more/collection.dart';

final min = 1;
final max = 20;

void main() {
  var result = range(min, max + 1).fold(1, lcm);
  assert(result == 232792560);
}
