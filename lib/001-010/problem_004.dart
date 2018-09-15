/// Problem 4: Largest palindrome product
///
/// A palindromic number reads the same both ways. The largest palindrome made
/// from the product of two 2-digit numbers is 9009 = 91 99.
///
/// Find the largest palindrome made from the product of two 3-digit numbers.
library euler.problem_004;

import 'package:more/collection.dart';

final min = 100;
final max = 999;

bool isPalindrome(int p) {
  final s = p.toString();
  return IntegerRange(s.length ~/ 2).every((i) => s[i] == s[s.length - i - 1]);
}

void main() {
  var c = -1;
  for (var i = max; i >= min; i--) {
    for (var j = i; j >= min; j--) {
      final p = i * j;
      if (p > c && isPalindrome(p)) {
        c = p;
      }
    }
  }
  assert(c == 906609);
}
