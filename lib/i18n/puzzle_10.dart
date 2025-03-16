import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:more/collection.dart';

final passwordCache = <String, bool>{};

bool verifyPassword(String password, String hash) => passwordCache.putIfAbsent(
  '$password/$hash',
  () => BCrypt.checkpw(password, hash),
);

int run(String filename) {
  final input = File(filename).readAsStringSync();
  final parts =
      input
          .split('\n\n')
          .map(
            (part) => part.split('\n').map((line) => line.split(' ')).toList(),
          )
          .toList();
  final passwords = parts.first.toMap(
    key: (line) => line[0],
    value: (line) => line[1],
  );
  var valid = 0;
  for (final [name, attempt] in parts.last) {
    final variants = <List<String>>[];
    for (final rune in attempt.normalize().runes) {
      final composed = String.fromCharCode(rune);
      final decomposed = composed.normalize(form: NormalizationForm.nfd);
      variants.add([composed, if (composed != decomposed) decomposed]);
    }
    for (final variant in variants.product()) {
      if (verifyPassword(variant.join(), passwords[name]!)) {
        valid++;
        break;
      }
    }
  }
  return valid;
}

void main() {
  assert(run('lib/i18n/puzzle_10_test.txt') == 4);
  assert(run('lib/i18n/puzzle_10_input.txt') == 1824);
}
