// Problem 38: Pandigital multiples
//
// Take the number 192 and multiply it by each of 1, 2, and 3:
//
//   192 x 1 = 192
//   192 x 2 = 384
//   192 x 3 = 576
//
// By concatenating each product we get the 1 to 9 pandigital, 192384576. We
// will call 192384576 the concatenated product of 192 and (1,2,3)
//
// The same can be achieved by starting with 9 and multiplying by 1, 2, 3, 4,
// and 5, giving the pandigital, 918273645, which is the concatenated product
// of 9 and (1,2,3,4,5).
//
// What is the largest 1 to 9 pandigital 9-digit number that can be formed as
// the concatenated product of an integer with (1,2, ... , n) where n > 1?
import 'package:more/math.dart';

int number(int n, int x) {
  final result = <int>[];
  for (var i = n; i > 0; i--) {
    result.addAll((i * x).digits());
  }
  return result.polynomial().toInt();
}

bool isPandigital(int x) {
  final decimals = x.digits();
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
  for (var n = 2; n <= 9; n++) {
    for (var x = 1; x < 987654321; x++) {
      final candidate = number(n, x);
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
