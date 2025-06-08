import 'dart:io';

import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';
import 'package:petitparser/expression.dart';
import 'package:petitparser/parser.dart';

const asciiMatcher = CharMatcher.ascii();
const digitMatcher = CharMatcher.digit();

const lri = '\u2066';
const rli = '\u2067';
const pdi = '\u2069';

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

void adjustBidi(List<dynamic> elements, [int level = 0]) {
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
  for (final line in input) {
    stdout.writeln('rex:  $line');
    stdout.writeln(
      ' = ${evaluator.parse(asciiMatcher.retainFrom(line)).value}',
    );

    final parts = <dynamic>[];
    final stack = <List<dynamic>>[parts];
    for (final char in line.toList(unicode: true)) {
      if (char == rli) {
        if (stack.length.isOdd) {
          final current = <dynamic>[];
          stack.last.add(current);
          stack.add(current);
        }
      } else if (char == lri) {
        if (stack.length.isEven) {
          final current = <dynamic>[];
          stack.last.add(current);
          stack.add(current);
        }
      } else if (char == pdi) {
        stack.removeLast();
      } else if (digitMatcher.match(char.runes.single) &&
          stack.last.isNotEmpty &&
          stack.last.last is String &&
          (stack.last.last as String).isNotEmpty &&
          digitMatcher.match((stack.last.last as String).runes.first)) {
        stack.last.last = '${stack.last.last}$char';
      } else {
        stack.last.add(char);
      }
    }

    adjustBidi(parts);

    final corrected = (stack.first as Iterable).deepFlatten<String>().join();

    stdout.writeln('lynx: $corrected');
    stdout.writeln(' = ${evaluator.parse(corrected).value}');
    stdout.writeln('');
  }

  // TODO: solve the puzzle
  return input.length;
}

void main() {
  stdout.writeln(run('lib/i18n/puzzle_18_test.txt'));
  stdout.writeln(run('lib/i18n/puzzle_18_input.txt'));
  assert(false, 'Add assertions for solved puzzle');
}
