/// Problem 38: Pandigital multiples
///
/// Take the number 192 and multiply it by each of 1, 2, and 3:
///
///   192 x 1 = 192
///   192 x 2 = 384
///   192 x 3 = 576
///
/// By concatenating each product we get the 1 to 9 pandigital, 192384576. We
/// will call 192384576 the concatenated product of 192 and (1,2,3)
///
/// The same can be achieved by starting with 9 and multiplying by 1, 2, 3, 4,
/// and 5, giving the pandigital, 918273645, which is the concatenated product
/// of 9 and (1,2,3,4,5).
///
/// What is the largest 1 to 9 pandigital 9-digit number that can be formed as
/// the concatenated product of an integer with (1,2, ... , n) where n > 1?
library problem_038;

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';

int number(int n, int x) {
  var result = new List();
  for (int i = n; i > 0; i--) {
    result.addAll(digits(i * x));
  }
  return polynomial(result);
}

bool isPandigital(int x) {
  var decimals = digits(x);
  if (decimals.length != 9) {
    return false;
  }
  for (var i = 1; i <= 9; i++) {
    if (!decimals.contains(i)) {
      return false;
    }
  }
  return true;
}

void main() {
  var max = 0;
  for (int n = 2; n <= 9; n++) {
    for (int x = 1; x < 987654321; x++) {
      var candidate = number(n, x);
      if (candidate > 987654321) {
        break;
      }
      if (isPandigital(candidate) && candidate > max) {
        max = candidate;
      }
    }
  }
  assert(max == 932718654);
}
