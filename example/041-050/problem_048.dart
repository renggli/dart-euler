/**
 * Problem 48: Self powers
 *
 * The series, 1^1 + 2^2 + 3^3 + ... + 10^10 = 10405071317.
 *
 * Find the last ten digits of the series, 1^1 + 2^2 + 3^3 + ... + 1000^1000.
 */
library problem_048;

import 'package:more/int_math.dart';
import 'package:more/collection.dart';

final max = 1000;

void main() {
  var sum = range(1, max + 1)
      .map((i) => pow(i, i))
      .reduce((a, b) => a + b);
  assert(sum % pow(10, 10) == 9110846700);
}
