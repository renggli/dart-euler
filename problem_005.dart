/**
 * Problem 5: Smallest multiple
 *
 * 2520 is the smallest number that can be divided by each of the numbers
 * from 1 to 10 without any remainder.
 *
 * What is the smallest positive number that is evenly divisible by all of the
 * numbers from 1 to 20?
 */
library problem_005;

int gcd(int a, int b) {
  while (b != 0) {
    var t = b;
    b = a % b;
    a = t;
  }
  return a;
}

int lcm(int a, int b) {
  return a * b ~/ gcd(a, b);
}

void main() {
  var min = 1;
  var max = 20;

  var result = 1;
  for (int i = min; i <= max; i++) {
    result = lcm(result, i);
  }
  print(result); // 232792560
}
