import 'dart:io';

import 'package:more/more.dart';

final vowel = CharMatcher.pattern('aeiou');

bool isValid(String password) {
  final letters = UnicodeCharMatcher.letter()
      .retainFrom(password.normalize(form: NormalizationForm.nfd))
      .toLowerCase();
  return password.length.between(4, 12) &&
      UnicodeCharMatcher.numberDecimalDigit().countIn(password) >= 1 &&
      vowel.countIn(letters) >= 1 &&
      (~vowel).countIn(letters) >= 1 &&
      letters.runes.length == letters.runes.toSet().length;
}

int run(String filename) => File(filename).readAsLinesSync().count(isValid);

void main() {
  assert(run('lib/i18n/puzzle_08_test.txt') == 2);
  assert(run('lib/i18n/puzzle_08_input.txt') == 809);
}
