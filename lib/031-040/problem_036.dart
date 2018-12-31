/// Problem 36: Double-base palindromes
///
/// The decimal number, 585 = 1001001001_2 (binary), is palindromic in both
/// bases.
///
/// Find the sum of all numbers, less than one million, which are palindromic in
/// base 10 and base 2.
///
/// (Please note that the palindromic number, in either base, may not include
/// leading zeros.)
library euler.problem_036;

import 'package:more/collection.dart';
import 'package:more/iterable.dart';

const int max = 1000000;

bool isPalindrom(List<int> digits) {
  for (var i = 0, j = digits.length - 1; i < j; i++, j--) {
    if (digits[i] != digits[j]) {
      return false;
    }
  }
  return true;
}

void main() {
  assert(IntegerRange(max)
          .where((value) =>
              isPalindrom(digits(value, 10).toList()) &&
              isPalindrom(digits(value, 2).toList()))
          .reduce((a, b) => a + b) ==
      872187);
}
