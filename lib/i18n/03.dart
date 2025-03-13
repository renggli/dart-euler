import 'dart:io';

import 'package:more/more.dart';

bool isValid(String password) =>
    password.length.between(4, 12) &&
    UnicodeCharMatcher.numberDecimalDigit().countIn(password) >= 1 &&
    UnicodeCharMatcher.letterUppercase().countIn(password) >= 1 &&
    UnicodeCharMatcher.letterLowercase().countIn(password) >= 1 &&
    (~const CharMatcher.ascii()).countIn(password) >= 1;

int run(String filename) => File(filename).readAsLinesSync().count(isValid);

void main() {
  assert(run('lib/i18n/03-test.txt') == 2);
  assert(run('lib/i18n/03-input.txt') == 509);
}
