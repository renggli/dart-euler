/// Problem 50: Consecutive prime sum
///
/// The prime 41, can be written as the sum of six consecutive primes:
///
/// 41 = 2 + 3 + 5 + 7 + 11 + 13
///
/// This is the longest sum of consecutive primes that adds to a prime below
/// one-hundred.
///
/// The longest sum of consecutive primes below one-thousand that adds to a
/// prime, contains 21 terms, and is equal to 953.
///
/// Which prime, below one-million, can be written as the sum of the most
/// consecutive primes?
library euler.problem_050;

import 'package:more/int_math.dart';
import 'package:more/ordering.dart';

final Ordering<int> ordering = new Ordering.natural();
final List<int> primes = primesUpTo(1000000);

void main() {
  var length = 0, prime = 0;
  for (var start = 0; start < primes.length; start++) {
    var sum = 0;
    for (var stop = start; stop < primes.length; stop++) {
      sum += primes[stop];
      var index = ordering.binarySearch(primes, sum);
      if (-index > primes.length) {
        break; // sum too large
      }
      if (stop - start > length && index >= 0) {
        length = stop - start + 1;
        prime = sum;
      }
    }
  }
  assert(prime == 997651);
}
