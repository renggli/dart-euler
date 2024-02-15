// Problem 21: Amicable numbers
//
// Let d(n) be defined as the sum of proper divisors of n (numbers less than n
// which divide evenly into n).
//
// If d(a) = b and d(b) = a, where a != b, then a and b are an amicable pair
// and each of a and b are called amicable numbers.
//
// For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44,
// 55 and 110; therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4,
// 71 and 142; so d(284) = 220.
//
// Evaluate the sum of all the amicable numbers under 10000.
const max = 10000;

int sumOfProperDivisors(int n) {
  var s = 1, d = 2;
  while (d * d < n) {
    if (n % d == 0) {
      s += d + n ~/ d;
    }
    d++;
  }
  if (d * d == n) {
    s += d;
  }
  return s;
}

void main() {
  var sum = 0;
  for (var a = 1; a <= max; a++) {
    final b = sumOfProperDivisors(a);
    if (a < b && b <= max && sumOfProperDivisors(b) == a) {
      sum += a + b;
    }
  }
  assert(sum == 31626);
}
