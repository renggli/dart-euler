/// Problem 53: Combinatoric selections
///
/// There are exactly ten ways of selecting three from five, 12345:
///
///   123, 124, 125, 134, 135, 145, 234, 235, 245, and 345
///
/// In combinatorics, we use the notation, 5C3 = 10.
///
/// In general,
///
///   nCr = n! / r!(n-r)!, where r <= n, n! = n(n-1)...3*2*1, and 0! = 1.
///
/// It is not until n = 23, that a value exceeds one-million: 23C10 = 1144066.
///
/// How many, not necessarily distinct, values of  nCr, for 1  n  100, are
/// greater than one-million?
library euler.problem_053;

BigInt binomial(int n, int k) {
  if (k < 0 || k > n) {
    throw ArgumentError('binomial($n, $k) is undefined for arguments.');
  }
  if (k == 0 || k == n) {
    return BigInt.zero;
  }
  if (k == 1 || k == n - 1) {
    return BigInt.from(n);
  }
  if (k > n - k) {
    k = n - k;
  }
  var r = BigInt.one;
  for (var i = 1; i <= k; i++) {
    r *= BigInt.from(n--);
    r = r ~/ BigInt.from(i);
  }
  return r;
}

void main() {
  var tally = 0;
  var max = BigInt.from(1000000);
  for (var n = 1; n <= 100; n++) {
    for (var k = 0; k <= n; k++) {
      if (binomial(n, k) > max) {
        tally++;
      }
    }
  }
  assert(tally == 4075);
}
