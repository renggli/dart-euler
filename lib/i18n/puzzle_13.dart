import 'dart:convert';
import 'dart:io';

import 'package:charset/charset.dart';
import 'package:data/stats.dart';
import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';

final letter = UnicodeCharMatcher.letter();
const utf16d = Utf16Decoder();

int run(String filename) {
  final parts = File(filename).readAsStringSync().split('\n\n');
  final words =
      parts[0].split('\n').map((line) {
        final bytes =
            line.chunked(2).map((each) => int.parse(each, radix: 16)).toList();
        return [
          latin1.decode(bytes, allowInvalid: true),
          utf8.decode(bytes, allowMalformed: true),
          utf16d.decodeUtf16Be(bytes),
          utf16d.decodeUtf16Le(bytes),
        ].where(letter.everyOf).toList();
      }).toList();
  return parts[1]
      .split('\n')
      .map((line) => RegExp('^${line.trim()}\$', unicode: true))
      .map(
        (regexp) => 1 + words.indexWhere((each) => each.any(regexp.hasMatch)),
      )
      .sum();
}

void main() {
  assert(run('lib/i18n/puzzle_13_test.txt') == 47);
  assert(run('lib/i18n/puzzle_13_input.txt') == 12799);
}
