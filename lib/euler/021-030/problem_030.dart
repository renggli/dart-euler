/// Problem 30: Digit fifth powers
///
/// Surprisingly there are only three numbers that can be written as the
/// sum of fourth powers of their digits:
///
///    1634 = 1^4 + 6^4 + 3^4 + 4^4
///    8208 = 8^4 + 2^4 + 0^4 + 8^4
///    9474 = 9^4 + 4^4 + 7^4 + 4^4
///
/// As 1 = 1^4 is not a sum it is not included.
///
/// The sum of these numbers is 1634 + 8208 + 9474 = 19316.
///
/// Find the sum of all the numbers that can be written as the sum of
/// fifth powers of their digits.
import 'package:more/collection.dart';
import 'package:more/math.dart';

const int power = 5;
const int upper = 200000;

int sumOfDigitPowers(int number, int power) => number
    .toString()
    .codeUnits
    .fold(0, (sum, each) => sum + (each - 48).pow(power).toInt());

void main() {
  final sum = 2
      .to(upper)
      .where((i) => sumOfDigitPowers(i, power) == i)
      .reduce((a, b) => a + b);
  assert(sum == 443839);
}
