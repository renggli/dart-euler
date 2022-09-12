/// Problem 6: Sum square difference
///
/// The sum of the squares of the first ten natural numbers is,
///
///   1^2 + 2^2 + ... + 10^2 = 385
///
/// The square of the sum of the first ten natural numbers is,
///
///   (1 + 2 + ... + 10)^2 = 55^2 = 3025
///
/// Hence the difference between the sum of the squares of the first ten natural
/// numbers and the square of the sum is 3025 - 385 = 2640.
///
/// Find the difference between the sum of the squares of the first one hundred
/// natural numbers and the square of the sum.
import 'package:more/collection.dart';

const max = 100;

num sum(int start, int stop, num Function(int) callback) =>
    start.to(stop + 1).map(callback).reduce((a, b) => a + b);

void main() {
  final sumOfSquares = sum(1, max, (i) => i * i);
  final squareOfSums = sum(1, max, (i) => i) * sum(1, max, (i) => i);
  final total = squareOfSums - sumOfSquares;
  assert(total == 25164150);
}
