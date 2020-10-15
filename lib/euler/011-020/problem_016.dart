/// Problem 16: Power digit sum
///
/// 2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
///
/// What is the sum of the digits of the number 2^1000?
import 'package:more/math.dart';

void main() {
  final number = BigInt.from(2).pow(1000);
  final sum = number.digits().reduce((a, b) => a + b);
  assert(sum == 1366);
}
