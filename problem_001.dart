/**
 * Problem 1: Multiples of 3 and 5
 *
 * If we list all the natural numbers below 10 that are multiples of 3 or 5,
 * we get 3, 5, 6 and 9. The sum of these multiples is 23.
 *
 * Find the sum of all the multiples of 3 or 5 below 1000.
 */
library problem_001;

var max = 1000;

void main() {
  var total = 0;
  for (var i = 0; i < max; i++) {
    if (i % 3 == 0 || i % 5 == 0) {
      total += i;
    }
  }
  print(total); // 233168
}
