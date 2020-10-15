/// Problem 60: Prime pair sets
///
/// The primes 3, 7, 109, and 673, are quite remarkable. By taking any two
/// primes and concatenating them in any order the result will always be prime.
/// For example, taking 7 and 109, both 7109 and 1097 are prime. The sum of
/// these four primes, 792, represents the lowest sum for a set of four primes
/// with this property.
///
/// Find the lowest sum for a set of five primes for which any two primes
/// concatenate to produce another prime.
import 'package:more/math.dart';

final List<int> primes = 10000.primes.toList();

bool allPrime(List<List<num>> pairs) {
  for (final pair in pairs) {
    final s1 = pair[0].toString(), s2 = pair[1].toString();
    if (!int.parse('$s1$s2').isProbablyPrime ||
        !int.parse('$s2$s1').isProbablyPrime) {
      return false;
    }
  }
  return true;
}

void main() {
  for (var pi1 = 0; pi1 < primes.length; pi1++) {
    final p1 = primes[pi1];
    for (var pi2 = pi1 + 1; pi2 < primes.length; pi2++) {
      final p2 = primes[pi2];
      if (allPrime([
        [p1, p2]
      ])) {
        for (var pi3 = pi2 + 1; pi3 < primes.length; pi3++) {
          final p3 = primes[pi3];
          if (allPrime([
            [p1, p3],
            [p2, p3]
          ])) {
            for (var pi4 = pi3 + 1; pi4 < primes.length; pi4++) {
              final p4 = primes[pi4];
              if (allPrime([
                [p1, p4],
                [p2, p4],
                [p3, p4]
              ])) {
                for (var pi5 = pi4 + 1; pi5 < primes.length; pi5++) {
                  final p5 = primes[pi5];
                  if (allPrime([
                    [p1, p5],
                    [p2, p5],
                    [p3, p5],
                    [p4, p5]
                  ])) {
                    assert(p1 + p2 + p3 + p4 + p5 == 26033);
                    return;
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  assert(false);
}
