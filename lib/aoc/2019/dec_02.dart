import 'dart:io';

final data = File('lib/aoc/2019/dec_02.txt')
    .readAsStringSync()
    .split(',')
    .map(int.parse)
    .toList();

void run(List<int> memory) {
  var ip = 0;
  while (true) {
    switch (memory[ip]) {
      case 1:
        memory[memory[ip + 3]] =
            memory[memory[ip + 1]] + memory[memory[ip + 2]];
        ip += 4;
      case 2:
        memory[memory[ip + 3]] =
            memory[memory[ip + 1]] * memory[memory[ip + 2]];
        ip += 4;
      case 99:
        return;
      default:
        throw StateError('Invalid op code ${memory[ip]} at $ip');
    }
  }
}

int problem1() {
  final memory = data.toList();
  memory[1] = 12;
  memory[2] = 2;
  run(memory);
  return memory[0];
}

int problem2() {
  for (var noun = 0; noun < 100; noun++) {
    for (var verb = 0; verb < 100; verb++) {
      final memory = data.toList();
      memory[1] = noun;
      memory[2] = verb;
      run(memory);
      if (memory[0] == 19690720) {
        return 100 * noun + verb;
      }
    }
  }
  throw StateError('Not found');
}

void main() {
  assert(problem1() == 8017076);
  assert(problem2() == 3146);
}
