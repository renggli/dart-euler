class OpCode {
  static const add = 1;
  static const mul = 2;
  static const get = 3;
  static const put = 4;
  static const jumpIfTrue = 5;
  static const jumpIfFalse = 6;
  static const lessThan = 7;
  static const equals = 8;
  static const adjustRelativeBase = 9;
  static const exit = 99;
}

const opMask = 100;

const opLength = {
  OpCode.add: 4,
  OpCode.mul: 4,
  OpCode.get: 2,
  OpCode.put: 2,
  OpCode.jumpIfTrue: 3,
  OpCode.jumpIfFalse: 3,
  OpCode.lessThan: 4,
  OpCode.equals: 4,
  OpCode.adjustRelativeBase: 2,
  OpCode.exit: 1,
};

const opName = {
  OpCode.add: 'add',
  OpCode.mul: 'mul',
  OpCode.get: 'get',
  OpCode.put: 'put',
  OpCode.jumpIfTrue: 'jump-if-true',
  OpCode.jumpIfFalse: 'jump-if-false',
  OpCode.lessThan: 'less-than',
  OpCode.equals: 'equals',
  OpCode.adjustRelativeBase: 'adjust-relative-base',
  OpCode.exit: 'exit',
};

class AddressMode {
  static const position = 0;
  static const immediate = 1;
  static const relative = 2;
}

const addressModeMask = 10;

const addressModes = {
  1: 100,
  2: 1000,
  3: 10000,
};
