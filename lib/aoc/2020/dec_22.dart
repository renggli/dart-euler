import 'dart:io';

import 'package:data/stats.dart';
import 'package:more/more.dart';

final values = File('lib/aoc/2020/dec_22.txt')
    .readAsStringSync()
    .split('\n\n')
    .map((player) => player.split('\n').sublist(1).map(int.parse).toList())
    .toList();

int score(List<int> deck) => deck.reversed
    .toList()
    .indexed(start: 1)
    .map((each) => each.value * each.index)
    .sum();

int game1() {
  final deck1 = [...values[0]];
  final deck2 = [...values[1]];
  while (deck1.isNotEmpty && deck2.isNotEmpty) {
    final card1 = deck1.removeAt(0);
    final card2 = deck2.removeAt(0);
    if (card1 > card2) {
      deck1.addAll([card1, card2]);
    } else {
      deck2.addAll([card2, card1]);
    }
  }
  return score(deck1.length > deck2.length ? deck1 : deck2);
}

(int, List<int>) play2(List<int> deck1, List<int> deck2) {
  final seen = <String>{};
  for (;;) {
    if (!seen.add(deck1.join()) || !seen.add(deck2.join())) {
      return (1, deck1);
    } else if (deck1.isEmpty) {
      return (2, deck2);
    } else if (deck2.isEmpty) {
      return (1, deck1);
    }
    final card1 = deck1.removeAt(0);
    final card2 = deck2.removeAt(0);
    var winner = card1 > card2 ? 1 : 2;
    if (deck1.length >= card1 && deck2.length >= card2) {
      winner = play2(deck1.sublist(0, card1), deck2.sublist(0, card2)).first;
    }
    if (winner == 1) {
      deck1.addAll([card1, card2]);
    } else {
      deck2.addAll([card2, card1]);
    }
  }
}

int game2() => score(play2([...values[0]], [...values[1]]).last);

void main() {
  assert(game1() == 34566);
  assert(game2() == 31854);
}
