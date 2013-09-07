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

import 'package:more/int_math.dart';

final grid = 20;

void main() {
  assert(binomial(2 * grid, grid) == 137846528820);
}
