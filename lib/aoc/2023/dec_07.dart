import 'dart:io';

import 'package:collection/collection.dart';
import 'package:more/more.dart';

final data = File('lib/aoc/2023/dec_07.txt')
    .readAsLinesSync()
    .map((line) => line.split(RegExp(r'\s+')).toList())
    .map((pair) => (cards: pair[0].split(''), bid: int.parse(pair[1])))
    .toList();

typedef Hand = ({List<String> cards, int bid});

enum HandType {
  fiveOfAKind,
  fourOfAKind,
  fullHouse,
  threeOfAKind,
  twoPair,
  onePair,
  highCard,
}

HandType handStrength(Hand hand, {bool withJokers = false}) {
  final cards = hand.cards.toMultiset();
  final hasJoker = withJokers && hand.cards.contains('J');
  // Five of a kind, where all five cards have the same label: AAAAA
  if (cards.distinct.length == 1) {
    return HandType.fiveOfAKind;
  }
  // Four of a kind, where four cards have the same label and one card has a
  // different label: AA8AA
  if (cards.distinct.length == 2 && cards.counts.contains(4)) {
    if (hasJoker) return HandType.fiveOfAKind;
    return HandType.fourOfAKind;
  }
  // Full house, where three cards have the same label, and the remaining two
  // cards share a different label: 23332
  if (cards.distinct.length == 2 && cards.counts.contains(3)) {
    if (hasJoker) return HandType.fiveOfAKind;
    return HandType.fullHouse;
  }
  // Three of a kind, where three cards have the same label, and the remaining
  // two cards are each different from any other card in the hand: TTT98
  if (cards.distinct.length == 3 && cards.counts.contains(3)) {
    if (hasJoker) return HandType.fourOfAKind;
    return HandType.threeOfAKind;
  }
  // Two pair, where two cards share one label, two other cards share a second
  // label, and the remaining card has a third label: 23432
  if (cards.distinct.length == 3 && cards.counts.contains(2)) {
    if (hasJoker && cards['J'] == 2) return HandType.fourOfAKind;
    if (hasJoker && cards['J'] == 1) return HandType.fullHouse;
    return HandType.twoPair;
  }
  // One pair, where two cards share one label, and the other three cards have
  // a different label from the pair and each other: A23A4
  if (cards.distinct.length == 4 && cards.counts.contains(2)) {
    if (hasJoker) return HandType.threeOfAKind;
    return HandType.onePair;
  }
  // High card, where all cards' labels are distinct: 23456
  if (cards.distinct.length == 5) {
    if (hasJoker) return HandType.onePair;
    return HandType.highCard;
  }
  throw StateError('Invalid strength: $hand');
}

int problem1() => data
    .sorted(explicitComparator(HandType.values)
        .onResultOf(handStrength)
        .thenCompare(explicitComparator('AKQJT98765432'.split(''))
            .lexicographical
            .onResultOf((hand) => hand.cards)))
    .indexed(start: data.length, step: -1)
    .fold(0, (result, entry) => result + entry.index * entry.value.bid);

int problem2() => data
    .sorted(explicitComparator(HandType.values)
        .onResultOf<Hand>((hand) => handStrength(hand, withJokers: true))
        .thenCompare(explicitComparator('AKQT98765432J'.split(''))
            .lexicographical
            .onResultOf((hand) => hand.cards)))
    .indexed(start: data.length, step: -1)
    .fold(0, (result, entry) => result + entry.index * entry.value.bid);

void main() {
  assert(problem1() == 250951660);
  assert(problem2() == 251481660);
}
