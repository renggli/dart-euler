/// Problem 51: Prime digit replacements
///
/// By replacing the 1st digit of the 2-digit number *3, it turns out that six
/// of the nine possible values: 13, 23, 43, 53, 73, and 83, are all prime.
///
/// By replacing the 3rd and 4th digits of 56**3 with the same digit, this
/// 5-digit number is the first example having seven primes among the ten
/// generated numbers, yielding the family: 56003, 56113, 56333, 56443,
/// 56663, 56773, and 56993. Consequently 56003, being the first member of this
/// family, is the smallest prime with this property.
///
/// Find the smallest prime which, by replacing part of the number (not
/// necessarily adjacent digits) with the same digit, is part of an eight prime
/// value family.
library euler.problem_051;

import 'package:more/iterable.dart';
import 'package:more/math.dart';

void main() {
  for (var prime in primesUpTo(1000000)) {
    if (prime > 100000) {
      final primeDigits = digits(prime);
      // need to check only repeating digits 0, 1, 2
      for (var repeating = 0; repeating < 3; repeating++) {
        // need to check only for digits that have 3 repeating digits
        if (primeDigits.where((digit) => digit == repeating).length == 3) {
          // find if this is a family of 8
          var count = 0;
          for (var replacement = 0; replacement < 10; replacement++) {
            final replacedDigits = primeDigits
                .map((digit) => digit == repeating ? replacement : digit);
            final replaced = polynomial(replacedDigits);
            if (replaced > 100000 && isProbablyPrime(replaced)) {
              count++;
            }
          }
          if (count == 8) {
            assert(prime == 121313);
            return;
          }
        }
      }
    }
  }
  assert(false);
}
