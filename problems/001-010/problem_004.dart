/**
 * Problem 4: Largest palindrome product
 *
 * A palindromic number reads the same both ways. The largest palindrome made
 * from the product of two 2-digit numbers is 9009 = 91 99.
 *
 * Find the largest palindrome made from the product of two 3-digit numbers.
 */
library problem_004;

bool isPalindrome(int p) {
  var s = p.toString();
  var m = s.length ~/ 2;
  for (int i = 0; i < m; i++) {
    if (s[i] != s[s.length - i - 1]) {
      return false;
    }
  }
  return true;
}

var min = 100;
var max = 999;

void main() {
  var c = -1;
  for (var i = max; i >= min; i--) {
    for (var j = i; j >= min; j--) {
      var p = i * j;
      if (p > c && isPalindrome(p)) {
        c = p;
      }
    }
  }
  assert(c == 906609);
}
