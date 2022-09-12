/// Problem 20: Factorial digit sum
///
/// n! means n  (n  1)  ...  3  2  1
///
/// For example, 10! = 10  9  ...  3  2  1 = 3628800,
/// and the sum of the digits in the number 10!
/// is 3 + 6 + 2 + 8 + 8 + 0 + 0 = 27.
///
/// Find the sum of the digits in the number 100!
import 'package:more/collection.dart';
import 'package:more/math.dart';

const number = 100;

void main() {
  final val = 1.to(100).fold<BigInt>(BigInt.one, (a, b) => a * BigInt.from(b));
  final sum = val.digits().fold<int>(0, (a, b) => a + b);
  assert(sum == 648);
}
