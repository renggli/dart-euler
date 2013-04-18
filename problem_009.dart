/**
 * Problem 9: Special Pythagorean triplet
 *
 * A Pythagorean triplet is a set of three natural numbers, a  b  c, for which,
 *
 *    a^2 + b^2 = c^2
 *
 * For example, 32 + 42 = 9 + 16 = 25 = 52.
 *
 * There exists exactly one Pythagorean triplet for which a + b + c = 1000.
 * Find the product abc.
 */
library problem_009;

var sum = 1000;

void main() {
  for (var a = 1; a <= sum - 2; a++) {
    for (var b = a; b <= sum - a - 1; b++) {
      var c = sum - a - b;
      if (a * a + b * b == c * c) {
        print(a * b * c); // 31875000
        return;
      }
    }
  }
}


