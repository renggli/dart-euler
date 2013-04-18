/**
 * Problem 3: Largest prime factor
 *
 * The prime factors of 13195 are 5, 7, 13 and 29.
 *
 * What is the largest prime factor of the number 600851475143 ?
 */
library problem_003;

import 'dart:math';
import 'dart:typeddata';

class BitSet {

  static final int BITS_PER_INDEX = 32;

  final Uint32List _buffer;

  BitSet._(this._buffer);

  factory BitSet(int size) {
    return new BitSet._(new Uint32List(1 + size ~/ BITS_PER_INDEX));
  }

  bool operator [] (int index) {
    var i = index ~/ BITS_PER_INDEX;
    var j = index % BITS_PER_INDEX;
    return (_buffer[i] & (1 << j)) != 0;
  }

  void operator []= (int index, bool value) {
    var i = index ~/ BITS_PER_INDEX;
    var j = index % BITS_PER_INDEX;
    if (value) {
      _buffer[i] |= (1 << j);
    } else {
      _buffer[i] &= ~(1 << j);
    }
  }

}

List<int> primesUpTo(int max) {
  List<int> primes = new List();
  BitSet sieve = new BitSet(1 + max);
  for (int i = 2; i <= max; i++) {
    if (!sieve[i]) {
      for (int j = i; j <= max; j += i) {
        sieve[j] = true;
      }
      primes.add(i);
    }
  }
  return primes;
}

var value = 600851475143;

void main() {
  var max = sqrt(value).ceil();
  for (int factor in primesUpTo(max).reversed) {
    if (value % factor == 0) {
      print(factor); // 6857
      return;
    }
  }
}
