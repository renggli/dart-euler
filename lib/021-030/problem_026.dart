/// Problem 26: Reciprocal cycles
///
/// A unit fraction contains 1 in the numerator. The decimal representation of
/// the unit fractions with denominators 2 to 10 are given:
///
/// 1/2 =   0.5
/// 1/3 =   0.(3)
/// 1/4 =   0.25
/// 1/5 =   0.2
/// 1/6 =   0.1(6)
/// 1/7 =   0.(142857)
/// 1/8 =   0.125
/// 1/9 =   0.(1)
/// 1/10  =   0.1
///
/// Where 0.1(6) means 0.166666..., and has a 1-digit recurring cycle. It can
/// be seen that 1/7 has a 6-digit recurring cycle.
///
/// Find the value of d < 1000 for which 1/d contains the longest recurring
/// cycle in its decimal fraction part.
library euler.problem_026;

const int d = 1000;

int cycleSize(int d) {
  final remainders = [1];
  while (remainders.last != 0) {
    if (remainders.last < d) {
      remainders.add(10 * remainders.last);
    } else {
      final r = 10 * (remainders.last % d);
      final i = remainders.indexOf(r);
      if (i > -1) {
        return remainders.length - i;
      }
      remainders.add(r);
    }
  }
  return 0;
}

void main() {
  var mi = 0, mc = 0;
  for (var i = 1; i < d; i++) {
    final c = cycleSize(i);
    if (mc < c) {
      mi = i;
      mc = c;
    }
  }
  assert(mi == 983);
}
