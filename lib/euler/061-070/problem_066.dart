/// Problem 66: Diophantine equation
///
/// Consider quadratic Diophantine equations of the form:
///
///   x^2 – Dy^2 = 1
///
/// For example, when D=13, the minimal solution in x is 649^2 – 13×180^2 = 1.
///
/// It can be assumed that there are no solutions in positive integers when D is
/// square.
///
/// By finding minimal solutions in x for D = {2, 3, 5, 6, 7}, we obtain the
/// following:
///
///   3^2 – 2×2^2 = 1
///   2^2 – 3×1^2 = 1
///   9^2 – 5×4^2 = 1
///   5^2 – 6×2^2 = 1
///   8^2 – 7×3^2 = 1
///
/// Hence, by considering minimal solutions in x for D ≤ 7, the largest x is
/// obtained when D=5.
///
/// Find the value of D ≤ 1000 in minimal solutions of x for which the largest
/// value of x is obtained.
import 'dart:math' as math;

/// The integer square root of `n` or `-1`.
int sqrt(int n) {
  final root = math.sqrt(n).round();
  return root * root == n ? root : -1;
}

const int searchMaxD = 7;

void main() {
  var maxX = 0, maxD = 0;
  for (var d = 2; d <= searchMaxD; d++) {
    if (sqrt(d) == -1) {
      for (var x = 2;; x++) {
        final upper = x * x - 1;
        if (upper % d == 0) {
          final y = sqrt(upper ~/ d);
          if (y > 0) {
            print('d: $d\tx: $x\ty: $y');
            if (x > maxX) {
              maxX = x;
              maxD = d;
            }
            break;
          }
        }
      }
    }
  }
  print('x: $maxX, D: $maxD');
  assert(false);
}
