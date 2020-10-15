/// Problem 53: Combinatoric selections
///
/// There are exactly ten ways of selecting three from five, 12345:
///
///   123, 124, 125, 134, 135, 145, 234, 235, 245, and 345
///
/// In combinatorics, we use the notation, 5C3 = 10.
///
/// In general,
///
///   nCr = n! / r!(n-r)!, where r <= n, n! = n(n-1)...3*2*1, and 0! = 1.
///
/// It is not until n = 23, that a value exceeds one-million: 23C10 = 1144066.
///
/// How many, not necessarily distinct, values of  nCr, for 1  n  100, are
/// greater than one-million?
import 'package:more/math.dart';

void main() {
  var tally = 0;
  final max = BigInt.from(1000000);
  for (var n = 1; n <= 100; n++) {
    final bn = BigInt.from(n);
    for (var k = 0; k <= n; k++) {
      final bk = BigInt.from(k);
      if (bn.binomial(bk) > max) {
        tally++;
      }
    }
  }
  assert(tally == 4075);
}
