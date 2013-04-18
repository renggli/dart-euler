/**
 * Problem 6: Sum square difference
 *
 * The sum of the squares of the first ten natural numbers is,
 *
 *   1^2 + 2^2 + ... + 10^2 = 385
 *
 * The square of the sum of the first ten natural numbers is,
 *
 *   (1 + 2 + ... + 10)^2 = 55^2 = 3025
 *
 * Hence the difference between the sum of the squares of the first ten natural
 * numbers and the square of the sum is 3025 - 385 = 2640.
 *
 * Find the difference between the sum of the squares of the first one hundred
 * natural numbers and the square of the sum.
 */
library problem_006;

num sum(int start, int stop, num fun(int)) {
  var result = 0;
  for (int i = start; i <= stop; i++) {
    result += fun(i);
  }
  return result;
}

void main() {
  var max = 100;

  var sum_of_squares = max * (max + 1) ~/ 2;
  var square_of_sums = sum(1, max, (i) => i) * sum(1, max, (i) => i);
  print(square_of_sums - sum_of_squares); // 25164150
}
