/**
 * Problem 20: Factorial digit sum
 *
 * n! means n  (n  1)  ...  3  2  1
 *
 * For example, 10! = 10  9  ...  3  2  1 = 3628800,
 * and the sum of the digits in the number 10!
 * is 3 + 6 + 2 + 8 + 8 + 0 + 0 = 27.
 *
 * Find the sum of the digits in the number 100!
 */
library problem_020;

import 'problem_015.dart';

void main() {
  var sum = (factorial(100).toString().codeUnits
      .map((each) => each - '0'.codeUnits.first)
      .reduce((a, b) => a + b));
  assert(sum == 648);
}
