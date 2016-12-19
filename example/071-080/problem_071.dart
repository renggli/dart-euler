/// Problem 71: Consider the fraction, n/d, where n and d are positive integers.
/// If n<d and HCF(n,d)=1, it is called a reduced proper fraction.
///
/// If we list the set of reduced proper fractions for d ≤ 8 in ascending order
/// of size, we get:
///
/// 1/8, 1/7, 1/6, 1/5, 1/4, 2/7, 1/3, 3/8, 2/5, 3/7, 1/2, 4/7, 3/5, 5/8, 2/3,
/// 5/7, 3/4, 4/5, 5/6, 6/7, 7/8
///
/// It can be seen that 2/5 is the fraction immediately to the left of 3/7.
///
/// By listing the set of reduced proper fractions for d ≤ 1,000,000 in
/// ascending order of size, find the numerator of the fraction immediately to
/// the left of 3/7.
library problem_071;

import 'package:more/fraction.dart';

final max_d = 1e6;

final Fraction target = new Fraction(3, 7);
final double target_float = target.toDouble();

void main() {
  var best = new Fraction(0, 1);
  var best_float =  best.toDouble();
  for (var d = 1; d <= max_d; d++) {
    for (var n = (d * target_float).floor(); n < d * target_float; n++) {
      var next_float = n / d;
      if (best_float < next_float && next_float < target_float) {
        best = new Fraction(n, d);
        best_float = best.toDouble();
      }
    }
  }
  assert(best.numerator == 428570);
}