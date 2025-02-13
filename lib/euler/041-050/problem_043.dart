// Problem 43: Sub-string divisibility
//
// The number, 1406357289, is a 0 to 9 pandigitial number because it is made up
// of each of the digits 0 to 9 in some order, but it also has a rather
// interesting sub-string divisibility property.
//
// Let d_1 be the 1st digit, d_2 be the 2nd, and so on. In this way, we note
// the following:
//
//    d_2, d_3, d_4 = 406 is divisible by 2
//    d_3, d_4, d_5 = 063 is divisible by 3
//    d_4, d_5, d_6 = 635 is divisible by 5
//    d_5, d_6, d_7 = 357 is divisible by 7
//    d_6, d_7, d_8 = 572 is divisible by 11
//    d_7, d_8, d_9 = 728 is divisible by 13
//    d_8, d_9, d_10 = 289 is divisible by 17
//
// Find the sum of all 0 to 9 pandigitial numbers with this property.
import 'package:data/stats.dart';
import 'package:more/collection.dart';
import 'package:more/math.dart';

const divisors = [2, 3, 5, 7, 11, 13, 17];

bool isDivisible(List<int> digits) {
  for (var i = 0; i < divisors.length; i++) {
    final sub = 100 * digits[8 - i] + 10 * digits[7 - i] + digits[6 - i];
    if (sub % divisors[i] != 0) {
      return false;
    }
  }
  return true;
}

void main() {
  final sum =
      0
          .to(10)
          .permutations()
          .where(isDivisible)
          .map((a) => a.polynomial())
          .sum();
  assert(sum == 16695334890);
}
