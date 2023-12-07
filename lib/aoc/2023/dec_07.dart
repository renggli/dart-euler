import 'dart:io';

import 'package:collection/collection.dart';
import 'package:data/data.dart';
import 'package:more/more.dart';

typedef Hand = ({List<String> cards, int bid});

final data = File('lib/aoc/2023/dec_07.txt')
    .readAsLinesSync()
    .map((line) => line.split(RegExp(r'\s+')).toList())
    .map((pair) => (
          cards: pair[0].split(''),
          bid: int.parse(pair[1]),
        ))
    .toList();

int handStrength(Hand hand, {bool withJokers = false}) {
  final cards = hand.cards.toMultiset();
  final hasJoker = withJokers && hand.cards.contains('J');

  // Five of a kind, where all five cards have the same label: AAAAA
  if (cards.distinct.length == 1) {
    return 6;
  }
  // Four of a kind, where four cards have the same label and one card has a
  // different label: AA8AA
  if (cards.distinct.length == 2 && cards.counts.contains(4)) {
    if (hasJoker) return 6;
    return 5;
  }
  // Full house, where three cards have the same label, and the remaining two
  // cards share a different label: 23332
  if (cards.distinct.length == 2 && cards.counts.contains(3)) {
    if (hasJoker) return 6;
    return 4;
  }
  // Three of a kind, where three cards have the same label, and the remaining
  // two cards are each different from any other card in the hand: TTT98
  if (cards.distinct.length == 3 && cards.counts.contains(3)) {
    if (hasJoker) return 5;
    return 3;
  }
  // Two pair, where two cards share one label, two other cards share a second
  // label, and the remaining card has a third label: 23432
  if (cards.distinct.length == 3 && cards.counts.contains(2)) {
    if (hasJoker && cards['J'] == 2) return 5;
    if (hasJoker && cards['J'] == 1) return 4;
    return 2;
  }
  // One pair, where two cards share one label, and the other three cards have
  // a different label from the pair and each other: A23A4
  if (cards.distinct.length == 4 && cards.counts.contains(2)) {
    if (hasJoker) return 3;
    return 1;
  }
  // High card, where all cards' labels are distinct: 23456
  if (cards.distinct.length == 5) {
    if (hasJoker) return 1;
    return 0;
  }
  throw StateError('Invalid strength: $hand');
}

final Comparator<Hand> handComparator1 = naturalCompare
    .onResultOf(handStrength)
    .thenCompare(explicitComparator('AKQJT98765432'.split('').reversed)
        .lexicographical
        .onResultOf((hand) => hand.cards));

int problem1() => data
    .sorted(handComparator1)
    .indexed(offset: 1)
    .map((entry) => entry.index * entry.value.bid)
    .reduce((a, b) => a + b);

final Comparator<Hand> handComparator2 = naturalCompare
    .onResultOf<Hand>((hand) => handStrength(hand, withJokers: true))
    .thenCompare(explicitComparator('AKQT98765432J'.split('').reversed)
        .lexicographical
        .onResultOf((hand) => hand.cards));

int problem2() => data
    .sorted(handComparator2)
    .indexed(offset: 1)
    .map((entry) => entry.index * entry.value.bid)
    .reduce((a, b) => a + b);

void main() {
  assert(problem1() == 250951660);
  assert(problem2() == 251481660);
}
