import 'dart:convert';
import 'dart:io';

import 'package:charset/charset.dart';
import 'package:more/collection.dart';

// dart format off
const utf8Length = [
  1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,
  2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,
  3,3,3,3,3,3,3,3, 3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4, 5,5,5,5,6,6,1,1,
];
// dart format on

List<int> decoded(List<int> input) {
  final result = <int>[];
  for (var i = 0; i < input.length;) {
    switch (utf8Length[input[i + 0]]) {
      case 1:
        result.add(input[i + 0]);
        i += 1;
      case 2:
        result.add(((input[i + 0] & 0x1f) << 6) + (input[i + 1] & 0x3f));
        i += 2;
      case 3:
        result.add(
          ((input[i + 0] & 0x0f) << 12) +
              ((input[i + 1] & 0x3f) << 6) +
              (input[i + 2] & 0x3f),
        );
        i += 3;
      case 4:
        result.add(
          ((input[i + 0] & 0x0f) << 18) +
              ((input[i + 1] & 0x3f) << 12) +
              ((input[i + 2] & 0x3f) << 6) +
              (input[i + 3] & 0x3f),
        );
        i += 4;
      case 5:
        result.add(
          ((input[i + 0] & 0x0f) << 24) +
              ((input[i + 1] & 0x3f) << 18) +
              ((input[i + 2] & 0x3f) << 12) +
              ((input[i + 3] & 0x3f) << 6) +
              (input[i + 4] & 0x3f),
        );
        i += 5;
      case 6:
        result.add(
          ((input[i + 0] & 0x01) << 30) +
              ((input[i + 1] & 0x3f) << 24) +
              ((input[i + 2] & 0x3f) << 18) +
              ((input[i + 3] & 0x3f) << 12) +
              ((input[i + 4] & 0x3f) << 6) +
              (input[i + 5] & 0x3f),
        );
        i += 6;
      default:
        throw StateError('Should never happen');
    }
  }
  return result;
}

int run(String filename) {
  final input = File(filename).readAsLinesSync().join();
  stdout.writeln('input: $input');

  final bytes = const Base64Decoder().convert(input);
  stdout.writeln('bytes; $bytes');

  final utf16le = const Utf16Decoder().decodeUtf16Le(bytes);
  stdout.writeln('utf16le: $utf16le');

  final runes = utf16le.runes
      .map((value) => value.toRadixString(16).padLeft(5, '0'))
      .join();
  stdout.writeln('runes: $runes');

  final regrouped = runes
      .chunked(2)
      .map((each) => int.parse(each, radix: 16))
      .toList();
  stdout.writeln('regrouped: $regrouped');

  final utf8long = decoded(regrouped);
  stdout.writeln('utf8long: $utf8long');

  final runes2 = utf8long
      .map((value) => value.toRadixString(16).padLeft(7, '0'))
      .join();
  stdout.writeln('runes2: $runes2');

  final regrouped2 = runes2
      .chunked(2)
      .map((value) => int.parse(value, radix: 16))
      .toList();
  stdout.writeln('regrouped2: $regrouped2');

  stdout.writeln(utf8.decode(regrouped2, allowMalformed: true));

  return 0;
}

void main() {
  stdout.writeln(run('lib/i18n/puzzle_20_test.txt'));
  stdout.writeln(run('lib/i18n/puzzle_20_input.txt'));
}
