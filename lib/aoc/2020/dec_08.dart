import 'dart:io';

class Code {
  Code(this.name, this.value);

  factory Code.parse(String line) {
    final parts = line.split(' ');
    return Code(parts[0], int.parse(parts[1]));
  }

  final String name;
  final int value;

  State run(State state) {
    switch (name) {
      case 'nop':
        return State(state.pc + 1, state.acc);
      case 'acc':
        return State(state.pc + 1, state.acc + value);
      case 'jmp':
        return State(state.pc + value, state.acc);
      default:
        throw StateError('Invalid code: $this');
    }
  }

  @override
  String toString() => '$name $value';
}

class State {
  State([this.pc = 0, this.acc = 0]);

  final int pc;
  final int acc;

  @override
  String toString() => 'pc: $pc, acc: $acc';
}

State run(State state, List<Code> codes) {
  final seen = <int>{};
  while (state.pc < codes.length && seen.add(state.pc)) {
    state = codes[state.pc].run(state);
  }
  return state;
}

int switchNopJmp(List<Code> codes) {
  for (var i = 0; i < codes.length; i++) {
    final copy = codes.toList();
    if (copy[i].name == 'nop') {
      copy[i] = Code('jmp', copy[i].value);
    } else if (copy[i].name == 'jmp') {
      copy[i] = Code('nop', copy[i].value);
    } else {
      continue;
    }
    final state = run(State(), copy);
    if (state.pc >= copy.length) {
      return state.acc;
    }
  }
  throw StateError('No terminating mutation found.');
}

final codes = File('lib/aoc/2020/dec_08.txt')
    .readAsLinesSync()
    .map(Code.parse)
    .toList();

void main() {
  assert(run(State(), codes).acc == 2034);
  assert(switchNopJmp(codes) == 672);
}
