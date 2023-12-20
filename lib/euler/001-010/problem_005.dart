/// Problem 5: Smallest multiple
///
/// 2520 is the smallest number that can be divided by each of the numbers
/// from 1 to 10 without any remainder.
///
/// What is the smallest positive number that is evenly divisible by all of the
/// numbers from 1 to 20?
import 'package:more/collection.dart';
import 'package:more/math.dart';

const min = 1;
const max = 20;

void main() {
  final result = min.to(max + 1).lcm();
  assert(result == 232792560);
}
