import 'dart:io';

import 'package:more/more.dart';

final input = File('lib/aoc/2020/dec_19.txt').readAsStringSync().split('\n\n');
final rules = input[0]
    .split('\n')
    .map((line) => line.split(': '))
    .toMap(
      key: (line) => line[0],
      value: (line) => line[1]
          .split(' | ')
          .map(
            (value) => value
                .split(' ')
                .map((value) => value.startsWith('"') ? value[1] : value)
                .toList(),
          )
          .toList(),
    );
final messages = input[1].split('\n');

bool isMatch(String message, [List<String> pending = const ['0']]) {
  if (message.isEmpty || pending.isEmpty) {
    return message.isEmpty == pending.isEmpty;
  } else if (rules.containsKey(pending.first)) {
    return rules[pending.first]!.any(
      (each) => isMatch(message, [...each, ...pending.sublist(1)]),
    );
  } else {
    return message[0] == pending.first &&
        isMatch(message.substring(1), pending.sublist(1));
  }
}

int part1() => messages.where(isMatch).length;

int part2() {
  rules['8'] = [
    ['42'],
    ['42', '8'],
  ];
  rules['11'] = [
    ['42', '31'],
    ['42', '11', '31'],
  ];
  return messages.where(isMatch).length;
}

void main() {
  assert(part1() == 184);
  assert(part2() == 389);
}
