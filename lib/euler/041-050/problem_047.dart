/// Problem 47: Distinct primes factors
///
/// The first two consecutive numbers to have two distinct prime factors are:
///
///   14 = 2 * 7
///   15 = 3 * 5
///
/// The first three consecutive numbers to have three distinct prime factors
/// are:
///
///   644 = 2 * 2 * 7 * 23
///   645 = 3 * 5 * 43
///   646 = 2 * 17 * 19.
///
/// Find the first four consecutive integers to have four distinct prime
/// factors. What is the first of these numbers?
const size = 4;

int count(int n) {
  var d = 2;
  final distinct = <int>{};
  while (n > 1) {
    while (n % d == 0) {
      distinct.add(d);
      n = n ~/ d;
    }
    d++;
  }
  return distinct.length;
}

void main() {
  final list = <int>[];
  for (var i = 2;; i++) {
    list.add(count(i));
    if (list.length > size) {
      list.removeAt(0);
      if (list.every((each) => each == size)) {
        assert(i - size + 1 == 134043);
        return;
      }
    }
  }
}
