import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:data/data.dart';
import 'package:petitparser/petitparser.dart';

final data = File('lib/aoc/2023/dec_19.txt').readAsStringSync().split('\n\n');

final workflowOperation = seq2(
  seq4(
    letter().plus().flatten(),
    anyOf('<>'),
    digit().plus().flatten().map(int.parse),
    char(':'),
  ).map4((a, op, b, _) => (a: a, op: op, b: b)).optional(),
  letter().plus().flatten(),
).map2((cond, then) => (cond: cond, then: then));
final workflowParser =
    seq4(
          letter().plus().flatten(),
          char('{'),
          workflowOperation.starSeparated(char(',')),
          char('}'),
        )
        .map4((id, _, ops, _) => MapEntry(id, ops.elements))
        .starSeparated(char('\n'))
        .map((list) => Map.fromEntries(list.elements))
        .end();
final workflows = workflowParser.parse(data.first).value;

final ratingParser =
    seq3(
          char('{'),
          seq3(any(), char('='), digit().plus().flatten().map(int.parse))
              .map3((name, _, value) => MapEntry(name, value))
              .starSeparated(char(','))
              .map((list) => Map.fromEntries(list.elements)),
          char('}'),
        )
        .map3((_, value, _) => value)
        .starSeparated(char('\n'))
        .map((list) => list.elements)
        .end();
final ratings = ratingParser.parse(data.last).value;

String eval(String state, Map<String, int> rating) {
  while (state != 'A' && state != 'R') {
    for (final step in workflows[state]!) {
      if (step.cond case (a: final a, op: final op, b: final b)) {
        if ((op == '<' && rating[a]! < b) || (op == '>' && rating[a]! > b)) {
          state = step.then;
          break;
        }
      } else {
        state = step.then;
        break;
      }
    }
  }
  return state;
}

int problem1() =>
    ratings
        .where((rating) => eval('in', rating) == 'A')
        .map((rating) => rating.values.sum())
        .sum();

int count(String state, Map<String, List<int>> rating) {
  final total = rating.values.map((each) => each.length).product();
  if (total == 0 || state == 'R') return 0;
  if (state == 'A') return total;
  var result = 0;
  for (final step in workflows[state]!) {
    if (step.cond case (a: final a, op: final op, b: final b)) {
      final values = rating[a]!;
      final cond = op == '<' ? (int v) => v < b : (int v) => v > b;
      result += count(step.then, {...rating, a: values.where(cond).toList()});
      rating = {...rating, a: values.whereNot(cond).toList()};
    } else {
      result += count(step.then, rating);
    }
  }
  return result;
}

int problem2() {
  final values = List.generate(4000, (index) => index + 1);
  return count('in', {'x': values, 'm': values, 'a': values, 's': values});
}

void main() {
  assert(problem1() == 348378);
  assert(problem2() == 121158073425385);
}
