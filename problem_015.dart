/**
 * Problem 15: Lattice paths
 *
 * Starting in the top left corner of a 2 x 2 grid, and only being
 * able to move to the right and down, there are exactly 6 routes to the bottom
 * right corner.
 *
 * How many such routes are there through a 20 x 20 grid?
 */
library problem_015;

/**
 * The number of ways to arrange [n] distinct objects into a sequence.
 */
int factorial(int value) {
  var result = 1;
  for (var i = 2; i <= value; i++) {
    result *= i;
  }
  return result;
}

/**
 * The number of ways, disregarding order, that [k] objects can be chosen from
 * among [n] objects.
 */
int binominal(int n, int k) {
  return factorial(n) ~/ (factorial(k) * factorial(n - k));
}

var grid = 20;

void main() {
  print(binominal(2 * grid, grid)); // 137846528820
}
