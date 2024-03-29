// Problem 7: 10001st prime
//
// By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see
// that the 6th prime is 13.
//
// What is the 10001st prime number?
import 'package:more/math.dart';

const ith = 10001;

void main() {
  assert(EratosthenesPrimeSieve(1000000).primes.elementAt(ith - 1) == 104743);
}
