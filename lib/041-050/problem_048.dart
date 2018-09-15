/// Problem 48: Self powers
///
/// The series, 1^1 + 2^2 + 3^3 + ... + 10^10 = 10405071317.
///
/// Find the last ten digits of the series, 1^1 + 2^2 + 3^3 + ... + 1000^1000.
library euler.problem_048;

import 'package:more/collection.dart';

final max = 1000;

void main() {
  final sum = IntegerRange(1, max + 1)
      .map((i) => BigInt.from(i).pow(i))
      .reduce((a, b) => a + b);
  final digits = sum % BigInt.from(10).pow(10);
  assert(digits.toInt() == 9110846700);
}
