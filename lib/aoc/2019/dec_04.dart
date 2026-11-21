import 'package:more/more.dart';

final passwords = 146810.to(612564 + 1);

bool isMatchPart1(int password) =>
    reverseComparable<num>.isOrdered(password.digits()) &&
    password.digits().toMultiset().elementCounts.any((count) => count >= 2);

bool isMatchPart2(int password) =>
    reverseComparable<num>.isOrdered(password.digits()) &&
    password.digits().toMultiset().elementCounts.contains(2);

void main() {
  assert(isMatchPart1(111111) == true);
  assert(isMatchPart1(223450) == false);
  assert(isMatchPart1(123789) == false);
  assert(passwords.count(isMatchPart1) == 1748);

  assert(isMatchPart2(112233) == true);
  assert(isMatchPart2(123444) == false);
  assert(isMatchPart2(111122) == true);
  assert(passwords.count(isMatchPart2) == 1180);
}
