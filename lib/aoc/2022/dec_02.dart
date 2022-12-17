import 'dart:io';

import 'package:data/stats.dart';

enum State {
  rock(1),
  paper(2),
  scissors(3);

  const State(this.score);

  final int score;
}

const stateChars = <String, State>{
  'A': State.rock,
  'X': State.rock,
  'B': State.paper,
  'Y': State.paper,
  'C': State.scissors,
  'Z': State.scissors,
};

enum Result {
  loss(0),
  draw(3),
  win(6);

  const Result(this.score);

  final int score;
}

const resultChars = <String, Result>{
  'X': Result.loss,
  'Y': Result.draw,
  'Z': Result.win,
};

const results = <State, Map<State, Result>>{
  State.rock: {
    State.rock: Result.draw,
    State.paper: Result.win,
    State.scissors: Result.loss,
  },
  State.paper: {
    State.rock: Result.loss,
    State.paper: Result.draw,
    State.scissors: Result.win,
  },
  State.scissors: {
    State.rock: Result.win,
    State.paper: Result.loss,
    State.scissors: Result.draw,
  },
};

class Move1 {
  Move1(String move)
      : a = stateChars[move[0]]!,
        b = stateChars[move[2]]!;

  final State a;
  final State b;

  int get scoreB => results[a]![b]!.score + b.score;
}

class Move2 {
  Move2(String move)
      : a = stateChars[move[0]]!,
        o = resultChars[move[2]]!;

  final State a;
  final Result o;

  State get b =>
      results[a]!.entries.firstWhere((entry) => entry.value == o).key;

  int get scoreB => results[a]![b]!.score + b.score;
}

final input = File('lib/aoc/2022/dec_02.txt').readAsLinesSync();

void main() {
  assert(input.map((line) => Move1(line).scoreB).sum() == 11873);
  assert(input.map((line) => Move2(line).scoreB).sum() == 12014);
}
