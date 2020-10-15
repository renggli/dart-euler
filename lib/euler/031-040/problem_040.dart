/// Problem 40: Champernowne's constant
///
/// An irrational decimal fraction is created by concatenating the positive
/// integers:
///
///   0.12345678910*1*112131415161718192021...
///
/// It can be seen that the 12^th digit of the fractional part is 1.
///
/// If d_n represents the n^th digit of the fractional part, find the value of
/// the following expression.
///
///   d_1 * d_10 * d_100 * d_1000 * d_10000 * d_100000 * d_1000000
import 'package:more/math.dart';

void main() {
  var n = 1;
  final d = <int>[];
  while (d.length < 1000000) {
    d.addAll((n++).digits().toList().reversed);
  }
  assert(d[0] * d[9] * d[99] * d[999] * d[9999] * d[99999] * d[999999] == 210);
}
