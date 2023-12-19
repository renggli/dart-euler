import 'dart:io';

final data = File('lib/aoc/2019/dec_05.txt')
    .readAsStringSync()
    .split(',')
    .map(int.parse)
    .toList();

int read(List<int> memory, int ip, int param) {
  const masks = {1: 100, 2: 1000, 3: 10000};
  final mode = memory[ip] ~/ masks[param]!;
  switch (mode % 10) {
    case 0: // position mode
      return memory[memory[ip + param]];
    case 1: // immediate mode
      return memory[ip + param];
    default:
      throw StateError('Invalid op code ${memory[ip]} at $ip');
  }
}

List<int> run(List<int> memory, List<int> input) {
  var ip = 0, inputPos = 0;
  final output = <int>[];
  while (true) {
    switch (memory[ip] % 100) {
      case 1: // plus
        memory[memory[ip + 3]] = read(memory, ip, 1) + read(memory, ip, 2);
        ip += 4;
      case 2: // multiply
        memory[memory[ip + 3]] = read(memory, ip, 1) * read(memory, ip, 2);
        ip += 4;
      case 3: // input
        memory[memory[ip + 1]] = input[inputPos++];
        ip += 2;
      case 4: // output
        output.add(read(memory, ip, 1));
        ip += 2;
      case 5: // jump-if-true
        ip = read(memory, ip, 1) != 0 ? read(memory, ip, 2) : ip + 3;
      case 6: // jump-if-false
        ip = read(memory, ip, 1) == 0 ? read(memory, ip, 2) : ip += 3;
      case 7: // less than
        memory[memory[ip + 3]] =
            read(memory, ip, 1) < read(memory, ip, 2) ? 1 : 0;
        ip += 4;
      case 8: // equals
        memory[memory[ip + 3]] =
            read(memory, ip, 1) == read(memory, ip, 2) ? 1 : 0;
        ip += 4;
      case 99: // exit
        return output;
      default:
        throw StateError('Invalid op code ${memory[ip]} at $ip');
    }
  }
}

int problem1() => run(data.toList(), [1]).last;

int problem2() => run(data.toList(), [5]).single;

void main() {
  assert(problem1() == 9025675);
  assert(problem2() == 11981754);
}
