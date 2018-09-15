/// Problem 33: Digit canceling fractions
///
/// The fraction 49/98 is a curious fraction, as an inexperienced mathematician
/// in attempting to simplify it may incorrectly believe that 49/98 = 4/8, which
/// is correct, is obtained by cancelling the 9s.
///
/// We shall consider fractions like, 30/50 = 3/5, to be trivial examples.
///
/// There are exactly four non-trivial examples of this type of fraction, less
/// than one in value, and containing two digits in the numerator and
/// denominator.
///
/// If the product of these four fractions is given in its lowest common terms,
/// find the value of the denominator.
library euler.problem_033;

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';

void main() {
  // wow, this is the most ugly code so far
  var nump = 1, denp = 1;
  for (var num = 11; num <= 99; num++) {
    for (var den = num + 1; den <= 99; den++) {
      final gcd1 = gcd(num, den);
      if (gcd1 > 1 && num % 10 > 0 && den % 10 > 0) {
        final nums = digits(num).toList();
        final dens = digits(den).toList();
        final com = nums.contains(dens[0])
            ? dens[0]
            : nums.contains(dens[1]) ? dens[1] : 0;
        if (com > 0) {
          nums.remove(com);
          dens.remove(com);
          final numx = nums[0];
          final denx = dens[0];
          final gcdx = gcd(numx, denx);
          if (num ~/ gcd1 == numx ~/ gcdx && den ~/ gcd1 == denx ~/ gcdx) {
            nump *= num;
            denp *= den;
          }
        }
      }
    }
  }
  final gcdp = gcd(nump, denp);
  assert(denp ~/ gcdp == 100);
}
