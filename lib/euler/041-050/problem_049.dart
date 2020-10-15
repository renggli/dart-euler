/// Problem 49: Prime permutations
///
/// The arithmetic sequence, 1487, 4817, 8147, in which each of the terms
/// increases by 3330, is unusual in two ways: (i) each of the three terms
/// are prime, and, (ii) each of the 4-digit numbers are permutations of one
/// another.
///
/// There are no arithmetic sequences made up of three 1-, 2-, or 3-digit
/// primes, exhibiting this property, but there is one other 4-digit increasing
/// sequence.
///
/// What 12-digit number do you form by concatenating the three terms in this
/// sequence?
import 'package:more/math.dart';
import 'package:more/ordering.dart';

final Ordering<num> ordering = Ordering.natural();
final Ordering<Iterable<num>> listOrdering = ordering.lexicographical;
final List<int> primes = 9999.primes.skipWhile((x) => x <= 1487).toList();

bool isPermutation(int a, int b) {
  final ad = a.digits().toList()..sort();
  final bd = b.digits().toList()..sort();
  return listOrdering.compare(ad, bd) == 0;
}

void main() {
  for (var step = 2; step < 5000; step += 2) {
    for (final a in primes) {
      final b = a + step, c = b + step;
      if (ordering.binarySearch(primes, b) > 0 &&
          ordering.binarySearch(primes, c) > 0 &&
          isPermutation(a, b) &&
          isPermutation(b, c)) {
        assert(a == 2969 && b == 6299 && c == 9629);
        return;
      }
    }
  }
  assert(false);
}
