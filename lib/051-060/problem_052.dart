/// Problem 52: Permuted multiples
///
/// It can be seen that the number, 125874, and its double, 251748, contain
/// exactly the same digits, but in a different order.
///
/// Find the smallest positive integer, x, such that 2x, 3x, 4x, 5x, and 6x,
/// contain the same digits.
library euler.problem_052;

import 'package:more/iterable.dart';
import 'package:more/ordering.dart';

final Ordering<Iterable<int>> comparator =
    Ordering<int>.natural().lexicographical;

void main() {
  for (var x = 1;; x++) {
    final xd = digits(x).toList()..sort();
    for (var n = 2; n <= 6; n++) {
      final nd = digits(n * x).toList()..sort();
      if (nd.length > xd.length || comparator.compare(xd, nd) != 0) {
        break;
      }
      if (n == 6) {
        assert(x == 142857);
        return;
      }
    }
  }
}
