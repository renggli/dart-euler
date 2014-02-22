/**
 * Problem 25: 1000-digit Fibonacci number
 *
 * The Fibonacci sequence is defined by the recurrence relation:
 *
 *     F_n = F_n1 + F_n2, where F_1 = 1 and F_2 = 1.
 *
 * Hence the first 12 terms will be:
 *
 *     F_1 = 1
 *     F_2 = 1
 *     F_3 = 2
 *     F_4 = 3
 *     F_5 = 5
 *     F_6 = 8
 *     F_7 = 13
 *     F_8 = 21
 *     F_9 = 34
 *     F_10 = 55
 *     F_11 = 89
 *     F_12 = 144
 *
 * The 12th term, F_12, is the first term to contain three digits.
 *
 * What is the first term in the Fibonacci sequence to contain 1000 digits?
 */
library problem_025;

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';

final digits = 1000;
final limit = pow(10, digits - 1);

void main() {
  var count = fibonacci(1, 1)
      .takeWhile((v) => v < limit)
      .fold(1, (a, b) => a + 1);
  assert(count == 4782);
}
