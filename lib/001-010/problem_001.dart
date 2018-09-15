/// Problem 1: Multiples of 3 and 5
///
/// If we list all the natural numbers below 10 that are multiples of 3 or 5,
/// we get 3, 5, 6 and 9. The sum of these multiples is 23.
///
/// Find the sum of all the multiples of 3 or 5 below 1000.
library euler.problem_001;

import 'package:more/collection.dart';

final max = 1000;

void main() {
  final sum = IntegerRange(max)
      .where((i) => i % 3 == 0 || i % 5 == 0)
      .reduce((a, b) => a + b);
  assert(sum == 233168);
}
