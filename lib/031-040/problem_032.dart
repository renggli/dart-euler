/// Problem 32: Pandigital products
///
/// We shall say that an n-digit number is pandigital if it makes use of all
/// the digits 1 to n exactly once; for example, the 5-digit number, 15234,
/// is 1 through 5 pandigital.
///
/// The product 7254 is unusual, as the identity, 39 * 186 = 7254, containing
/// multiplicand, multiplier, and product is 1 through 9 pandigital.
///
/// Find the sum of all products whose multiplicand/multiplier/product identity
/// can be written as a 1 through 9 pandigital.
///
/// HINT: Some products can be obtained in more than one way so be sure to only
/// include it once in your sum.
library euler.problem_032;

import 'package:more/iterable.dart';

bool isPandigitalProduct(int a, int b) {
  var list = [];
  list.addAll(digits(a));
  list.addAll(digits(b));
  list.addAll(digits(a * b));
  return list.length == 9 && !list.contains(0)
      && new Set.from(list).length == list.length;
}

void main() {
  var products = new Set();
  for (var a = 1; a <= 98; a++) {
    for (var b = 123; b <= 9876; b++) {
      if (isPandigitalProduct(a, b)) {
        products.add(a * b);
      }
    }
  }
  assert(products.reduce((a, b) => a + b) == 45228);
}
