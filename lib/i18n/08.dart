import 'dart:io';

import 'package:more/more.dart';
import 'package:string_normalizer/string_normalizer.dart';

bool isValid(String password) {
  final normal = password.normalize().toLowerCase();
  return password.length.between(4, 12) &&
      UnicodeCharMatcher.numberDecimalDigit().countIn(password) >= 1 &&
      CharMatcher.pattern('aeiou').countIn(normal) >= 1 &&
      (UnicodeCharMatcher.letter() & CharMatcher.pattern('^aeiou')).countIn(
            normal,
          ) >=
          1 &&
      normal.runes.length == normal.runes.toSet().length;
}

int run(String filename) => File(filename).readAsLinesSync().count(isValid);

void main() {
  assert(run('lib/i18n/08-test.txt') == 2);
  assert(run('lib/i18n/08-input.txt') == 809);
}
