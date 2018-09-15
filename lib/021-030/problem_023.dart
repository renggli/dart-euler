/// Problem 23: Non-abundant sums
///
/// A perfect number is a number for which the sum of its proper divisors is
/// exactly equal to the number. For example, the sum of the proper divisors
/// of 28 would be 1 + 2 + 4 + 7 + 14 = 28, which means that 28 is a perfect
/// number.
///
/// A number n is called deficient if the sum of its proper divisors is less
/// than n and it is called abundant if this sum exceeds n.
///
/// As 12 is the smallest abundant number, 1 + 2 + 3 + 4 + 6 = 16, the smallest
/// number that can be written as the sum of two abundant numbers is 24. By
/// mathematical analysis, it can be shown that all integers greater than 28123
/// can be written as the sum of two abundant numbers. However, this upper limit
/// cannot be reduced any further by analysis even though it is known that the
/// greatest number that cannot be expressed as the sum of two abundant numbers
/// is less than this limit.
///
/// Find the sum of all the positive integers which cannot be written as the sum
/// of two abundant numbers.
library euler.problem_023;

import 'package:more/collection.dart';

import 'problem_021.dart';

final max = 28123;

void main() {
  var abundant = <int>[];
  for (var i = 1; i <= max; i++) {
    if (sumOfProperDivisors(i) > i) {
      abundant.add(i);
    }
  }
  var hasSum = BitList(max + 1);
  for (var i = 0; i < abundant.length; i++) {
    for (var j = i; j < abundant.length; j++) {
      var sum = abundant[i] + abundant[j];
      if (sum <= max) {
        hasSum[sum] = true;
      } else {
        break;
      }
    }
  }
  var sum = 0;
  for (var i = 0; i < max; i++) {
    if (!hasSum[i]) {
      sum += i;
    }
  }
  assert(sum == 4179871);
}
