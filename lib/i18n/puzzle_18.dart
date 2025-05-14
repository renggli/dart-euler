import 'dart:convert';
import 'dart:io';

import 'dart:math' as math;

import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';
import 'package:petitparser/expression.dart';
import 'package:petitparser/parser.dart';

const asciiMatcher = CharMatcher.ascii();
const digitMatcher = CharMatcher.digit();

const LRI = '\u2066';
const RLI = '\u2067';
const PDI = '\u2069';

var embeddingLevel = 0;

final evaluator = () {
  final builder = ExpressionBuilder<int>();
  builder.primitive(digit().plusString().map(int.parse));
  builder.group().wrapper(char('('), char(')'), (_, value, _) => value);
  builder.group()
    ..left(char('*').trim(), (left, operator, right) => left * right)
    ..left(char('/').trim(), (left, operator, right) => left ~/ right);
  builder.group()
    ..left(char('+').trim(), (left, operator, right) => left + right)
    ..left(char('-').trim(), (left, operator, right) => left - right);
  return builder.build().end();
}();

void adjustBidi(List elements, [int level = 0]) {
  for (var i = 0; i < elements.length; i++) {
    final element = elements[i];
    if (element is List) {
      if (level.isEven) {
        elements[i] = element.reversed.toList();
      }
      adjustBidi(element, level + 1);
    } else if (level.isOdd) {
      if (element == '(') {
        elements[i] = ')';
      } else if (element == ')') {
        elements[i] = '(';
      }
    }
  }
}

int run(String filename) {
  final input = File(filename).readAsLinesSync();
  for (var line in input) {
    print('rex:  $line');
    print(' = ${evaluator.parse(asciiMatcher.retainFrom(line)).value}');

    final parts = [];
    final stack = [parts];
    for (final char in line.toList(unicode: true)) {
      if (char == RLI) {
        if (stack.length.isOdd) {
          final current = <dynamic>[];
          stack.last.add(current);
          stack.add(current);
        }
      } else if (char == LRI) {
        if (stack.length.isEven) {
          final current = <dynamic>[];
          stack.last.add(current);
          stack.add(current);
        }
      } else if (char == PDI) {
        stack.removeLast();
      } else if (digitMatcher.match(char.runes.single) &&
          stack.last.isNotEmpty &&
          stack.last.last is String &&
          (stack.last.last as String).isNotEmpty &&
          digitMatcher.match((stack.last.last as String).runes.first)) {
        stack.last.last += char;
      } else {
        stack.last.add(char);
      }
    }

    adjustBidi(parts);

    final corrected = (stack.first as Iterable).deepFlatten<String>().join();

    print('lynx: $corrected');
    print(' = ${evaluator.parse(corrected).value}');
    print('');
  }

  // TODO: solve the puzzle
  return input.length;
}

void main() {
  print(run('lib/i18n/puzzle_18_test.txt'));
  //print(run('lib/i18n/puzzle_18_input.txt'));
}
