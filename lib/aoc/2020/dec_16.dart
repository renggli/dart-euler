import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/more.dart';

final field = RegExp(r'(.+): (\d+)-(\d+) or (\d+)-(\d+)');
final values = File('lib/aoc/2020/dec_16.txt').readAsStringSync().split('\n\n');

final fields =
    values[0].split('\n').map((line) => field.matchAsPrefix(line)!).toMap(
        key: (match) => match.group(1),
        value: (match) => {
              ...int.parse(match.group(2)!).to(int.parse(match.group(3)!) + 1),
              ...int.parse(match.group(4)!).to(int.parse(match.group(5)!) + 1),
            });
final yourTicket = values[1].split('\n')[1].split(',').map(int.parse).toList();
final nearbyTickets = values[2]
    .split('\n')
    .sublist(1)
    .map((line) => line.split(',').map(int.parse).toList())
    .toList();

final allFieldValues = fields.values.reduce((a, b) => {...a, ...b});
final validTickets = [yourTicket]
    .followedBy(nearbyTickets)
    .where(allFieldValues.containsAll)
    .toList();

int problem1() => nearbyTickets
    .map((ticket) =>
        ticket.where((value) => !allFieldValues.contains(value)).sum())
    .sum();

int problem2() {
  final fieldMap = <int, String>{};
  while (fieldMap.length < fields.length) {
    for (var i = 0; i < yourTicket.length; i++) {
      final fieldIndexes = validTickets.map((ticket) => ticket[i]).toSet();
      final fieldNames = fields.entries
          .where((entry) => !fieldMap.containsValue(entry.key))
          .where((entry) => entry.value.containsAll(fieldIndexes))
          .map((entry) => entry.key!)
          .toSet();
      if (fieldNames.length == 1) {
        fieldMap[i] = fieldNames.single;
      }
    }
  }
  return fieldMap.entries
      .where((entry) => entry.value.startsWith('departure'))
      .map((entry) => yourTicket[entry.key])
      .reduce((a, b) => a * b);
}

void main() {
  assert(problem1() == 26053);
  assert(problem2() == 1515506256421);
}
