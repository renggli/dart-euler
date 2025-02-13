import 'dart:io';

final lines = File('lib/aoc/2022/dec_05.txt').readAsLinesSync();

final stack = RegExp(r'( {3}|\[(\w)\]) ?');
final operation = RegExp(r'move (\d+) from (\d+) to (\d+)');

class Operation {
  Operation(this.quantity, this.from, this.to);

  final int quantity;
  final int from;
  final int to;

  @override
  String toString() => 'move $quantity from $from to $to';
}

void oneByOne(Operation operation, List<List<String>> stacks) {
  for (var i = 0; i < operation.quantity; i++) {
    stacks[operation.to].add(stacks[operation.from].removeLast());
  }
}

void allAtOnce(Operation operation, List<List<String>> stacks) {
  final source = stacks[operation.from], target = stacks[operation.to];
  final range = source.sublist(source.length - operation.quantity);
  source.removeRange(source.length - operation.quantity, source.length);
  target.addAll(range);
}

String run(void Function(Operation, List<List<String>>) perform) {
  final stacks = <List<String>>[];
  final operations = <Operation>[];
  for (final line in lines) {
    final matches = operation.matchAsPrefix(line);
    if (matches != null) {
      operations.add(
        Operation(
          int.parse(matches.group(1)!),
          int.parse(matches.group(2)!) - 1,
          int.parse(matches.group(3)!) - 1,
        ),
      );
    } else {
      final matches = stack.allMatches(line).toList();
      while (stacks.length < matches.length) {
        stacks.add(<String>[]);
      }
      for (var i = 0; i < matches.length; i++) {
        final content = matches[i].group(2);
        if (content != null) stacks[i].insert(0, content);
      }
    }
  }
  for (final operation in operations) {
    perform(operation, stacks);
  }
  return stacks.map((stack) => stack.last).join('');
}

void main() {
  assert(run(oneByOne) == 'FWSHSPJWM');
  assert(run(allAtOnce) == 'PWPWHGFZS');
}
