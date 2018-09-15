/// Problem 57: Square root convergents
///
/// It is possible to show that the square root of two can be expressed as an
/// infinite continued fraction.
///
///   sqrt(2) = 1 + 1/(2 + 1/(2 + 1/(2 + ... ))) = 1.414213...
///
/// By expanding this for the first four iterations, we get:
///
///   1 + 1/2 = 3/2 = 1.5
///   1 + 1/(2 + 1/2) = 7/5 = 1.4
///   1 + 1/(2 + 1/(2 + 1/2)) = 17/12 = 1.41666...
///   1 + 1/(2 + 1/(2 + 1/(2 + 1/2))) = 41/29 = 1.41379...
///
/// The next three expansions are 99/70, 239/169, and 577/408, but the eighth
/// expansion, 1393/985, is the first example where the number of digits in the
/// numerator exceeds the number of digits in the denominator.
///
/// In the first one-thousand expansions, how many fractions contain a numerator
/// with more digits than denominator?
library euler.problem_057;

void main() {
  var tally = 0;
  // fraction = two + half
  var fraction_n = BigInt.from(5);
  var fraction_d = BigInt.from(2);
  for (var i = 1; i <= 1000; i++) {
    // value = fraction - one
    var value_n = fraction_n - fraction_d;
    var value_d = fraction_d;
    if (value_n.toString().length > value_d.toString().length) {
      tally++;
    }
    // fraction = 2 + 1 / fraction
    var n_fraction_n = BigInt.two * fraction_n + fraction_d;
    var n_fraction_d = fraction_n;
    var n_faction_gcd = n_fraction_n.gcd(n_fraction_d);
    fraction_n = n_fraction_n ~/ n_faction_gcd;
    fraction_d = n_fraction_d ~/ n_faction_gcd;
  }
  assert(tally == 153);
}
