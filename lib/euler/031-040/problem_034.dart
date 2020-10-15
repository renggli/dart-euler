/// Problem 34: Digit factorials
///
/// 145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.
///
/// Find the sum of all numbers which are equal to the sum of the factorial of
/// their digits.
///
/// Note: as 1! = 1 and 2! = 2 are not sums they are not included.
import 'package:more/math.dart';

void main() {
  var t = 0;
  const m = 100000;
  for (var i = 3; i <= m; i++) {
    final s = i.digits().map((a) => a.factorial()).reduce((a, b) => a + b);
    if (i == s) {
      t += s;
    }
  }
  assert(t == 40730);
}
