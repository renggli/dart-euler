/// Problem 64: Odd period square roots
///
/// All square roots are periodic when written as continued fractions and can be
/// written in the form:
///
///   √N = a0 + 1 / (a1 + 1 / (a2 + 1 / (a3 + ...))))
///
/// For example, let us consider √23:
///
///   √23 = 4 + √23 — 4 = 4 + 1 / (1 / (√23 - 4)) = 4 + 1 / (1 + (√23 - 3) / 7
///
/// If we continue we would get the following expansion:
///
///   √23 = 4 + 1 / (1 + 1 / (3 + 1 / (1 + 1 / (8 + 1 / ...))))
///
/// It can be seen that the sequence is repeating. For conciseness, we use the
/// notation √23 = [4;(1,3,1,8)], to indicate that the block (1,3,1,8) repeats
/// indefinitely.
///
/// The first ten continued fraction representations of (irrational) square
/// roots are:
///
///   √2=[1;(2)], period=1
///   √3=[1;(1,2)], period=2
///   √5=[2;(4)], period=1
///   √6=[2;(2,4)], period=2
///   √7=[2;(1,1,1,4)], period=4
///   √8=[2;(1,4)], period=2
///   √10=[3;(6)], period=1
///   √11=[3;(3,6)], period=2
///   √12= [3;(2,6)], period=2
///   √13=[3;(1,1,1,1,6)], period=5
///
/// Exactly four continued fractions, for N ≤ 13, have an odd period.
///
/// How many continued fractions for N ≤ 10000 have an odd period?
import 'dart:math';

import 'package:more/collection.dart';

// https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Algorithm
Iterable<int> expansion(int n) sync* {
  final a0 = sqrt(n).floor();
  if (a0 * a0 != n) {
    var m = 0;
    var d = 1;
    var a = a0;
    do {
      m = d * a - m;
      d = (n - m * m) ~/ d;
      a = (a0 + m) ~/ d;
      yield a;
    } while (a != 2 * a0);
  }
}

void main() {
  assert(0.to(10000 + 1).map(expansion).where((e) => e.length.isOdd).length ==
      1322);
}
