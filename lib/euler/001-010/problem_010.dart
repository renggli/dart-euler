// Problem 10: Summation of primes
//
// The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
//
// Find the sum of all the primes below two million.
import 'package:data/stats.dart';
import 'package:more/math.dart';

const max = 2000000;

void main() {
  final sum = EratosthenesPrimeSieve(max).primes.sum();
  assert(sum == 142913828922);
}
