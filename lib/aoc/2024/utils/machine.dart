class Machine {
  Machine(Iterable<int> registers, Iterable<int> program)
    : registers = registers.toList(growable: false),
      program = program.toList(growable: false) {
    assert(registers.length == 3, 'Exactly 3 registers expected');
  }

  final List<int> registers;
  final List<int> program;
  final List<int> output = [];

  int _ip = 0;

  List<int> run() {
    while (_ip < program.length) {
      step();
    }
    return output;
  }

  void step() {
    final opcode = program[_ip];
    final operand = program[_ip + 1];
    switch (opcode) {
      case 0: // adv instruction
        registers[registerA] = registers[registerA] >> _combo(operand);
      case 1: // bxl instruction
        registers[registerB] = registers[registerB] ^ operand;
      case 2: // bst instruction
        registers[registerB] = _combo(operand) & 7;
      case 3: // jnz instruction
        if (registers[registerA] != 0) {
          _ip = operand;
          return;
        }
      case 4: // bxc instruction
        registers[registerB] = registers[registerB] ^ registers[registerC];
      case 5: // out instruction
        output.add(_combo(operand) & 7);
      case 6: // bdv instruction
        registers[registerB] = registers[registerA] >> _combo(operand);
      case 7: // cdv instruction
        registers[registerC] = registers[registerA] >> _combo(operand);
      default:
        throw AssertionError('Invalid op-code: $opcode');
    }
    _ip += 2;
  }

  int _combo(int operand) =>
      operand <= 3
          ? operand // literal
          : operand <= 6
          ? registers[operand - 4] // register
          : throw AssertionError('Invalid operand: $operand');

  static const registerA = 0;
  static const registerB = 1;
  static const registerC = 2;
}
