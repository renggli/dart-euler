// Problem 66: Diophantine equation
//
// Consider quadratic Diophantine equations of the form:
//
//   x^2 – Dy^2 = 1
//
// For example, when D=13, the minimal solution in x is 649^2 – 13×180^2 = 1.
//
// It can be assumed that there are no solutions in positive integers when D is
// square.
//
// By finding minimal solutions in x for D = {2, 3, 5, 6, 7}, we obtain the
// following:
//
//   3^2 – 2×2^2 = 1
//   2^2 – 3×1^2 = 1
//   9^2 – 5×4^2 = 1
//   5^2 – 6×2^2 = 1
//   8^2 – 7×3^2 = 1
//
// Hence, by considering minimal solutions in x for D ≤ 7, the largest x is
// obtained when D=5.
//
// Find the value of D ≤ 1000 in minimal solutions of x for which the largest
// value of x is obtained.

import 'dart:math' as math;

bool isSquare(int value) {
  final root = math.sqrt(value).toInt();
  return root * root == value;
}

// http://en.wikipedia.org/wiki/Pell%27s_equation
// http://en.wikipedia.org/wiki/Chakravala_method
BigInt minimalSolution(int value) {
  final D = BigInt.from(value);
  final a0 = BigInt.from(math.sqrt(value).toInt());

  var m = BigInt.zero, d = BigInt.one, a = a0;
  var num1 = BigInt.one, num2 = a;
  var den1 = BigInt.zero, den2 = BigInt.one;

  while (num2 * num2 - D * den2 * den2 != BigInt.one) {
    m = d * a - m;
    d = (D - m * m) ~/ d;
    a = (a0 + m) ~/ d;
    (num1, num2) = (num2, a * num2 + num1);
    (den1, den2) = (den2, a * den2 + den1);
  }

  return num2;
}

void main() {
  var maxX = BigInt.zero;
  var maxD = 0;
  for (var d = 2; d <= 1000; d++) {
    if (!isSquare(d)) {
      final x = minimalSolution(d);
      if (x > maxX) {
        maxX = x;
        maxD = d;
      }
    }
  }
  assert(maxD == 661);
}
