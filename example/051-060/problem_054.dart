/// Problem 54: Poker hands
///
/// In the card game poker, a hand consists of five cards and are ranked, from
/// lowest to highest, in the following way:
///
///   High Card: Highest value card.
///   One Pair: Two cards of the same value.
///   Two Pairs: Two different pairs.
///   Three of a Kind: Three cards of the same value.
///   Straight: All cards are consecutive values.
///   Flush: All cards of the same suit.
///   Full House: Three of a kind and a pair.
///   Four of a Kind: Four cards of the same value.
///   Straight Flush: All cards are consecutive values of same suit.
///   Royal Flush: Ten, Jack, Queen, King, Ace, in same suit.
///
/// The cards are valued in the order:
///
///   2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King, Ace.
///
/// If two players have the same ranked hands then the rank made up of the
/// highest value wins; for example, a pair of eights beats a pair of fives
/// (see example 1 below). But if two ranks tie, for example, both players have
/// a pair of queens, then highest cards in each hand are compared (see example
/// 4 below); if the highest cards tie then the next highest cards are compared,
/// and so on.
///
/// Consider the following five hands dealt to two players:
///
///   Hand    Player 1              Player 2              Winner
///
///   1       5H 5C 6S 7S KD        2C 3S 8S 8D TD        Player 2
///           Pair of Fives         Pair of Eights
///
///   2       5D 8C 9S JS AC        2C 5C 7D 8S QH        Player 1
///           Highest card Ace      Highest card Queen
///
///   3       2D 9C AS AH AC        3D 6D 7D TD QD        Player 2
///           Three Aces            Flush with Diamonds
///
///   4       4D 6S 9H QH QC        3D 6D 7H QD QS        Player 1
///           Pair of Queens        Pair of Queens
///           Highest card Nine     Highest card Nine
///
///   5       2H 2D 4C 4D 4S        3C 3D 3S 9S 9D        Player 1
///           Full House            Full House
///           With Three Fours      With Three Threes
///
/// The file, poker.txt, contains one-thousand random hands dealt to two players. Each line of
/// the file contains ten cards (separated by a single space): the first five are Player 1's cards
/// and the last five are Player 2's cards. You can assume that all hands are valid (no invalid
/// characters or repeated cards), each player's hand is in no specific order, and in each hand
/// there is a clear winner.
///
/// How many hands does Player 1 win?
library problem_054;

import 'package:more/collection.dart';
import 'package:more/iterable.dart';

const List<String> values = const ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'];
const List<String> suits = const ['C', 'D', 'H', 'S'];

class Card {

  final String name;
  final int value;
  final int suit;

  factory Card(String input) {
    if (input.length != 2) {
      throw new ArgumentError('Invalid card: $input');
    }
    if (!values.contains(input[0])) {
      throw new ArgumentError('Invalid card value: $input');
    }
    if (!suits.contains(input[1])) {
      throw new ArgumentError('Invalid card suit: $input');
    }
    return new Card._(input, values.indexOf(input[0]) + 2, suits.indexOf(input[1]));
  }

  Card._(this.name, this.value, this.suit);

  @override
  String toString() => name;
}

class Hand {

  final List<Card> cards;
  final Multiset<int> values;
  final Multiset<int> suits;

  factory Hand(List<Card> input) {
    if (input.length != 5) {
      throw new ArgumentError('Invalid hand: $input');
    }
    List<Card> cards = new List.from(input)
        ..sort((a, b) => a.value - b.value);
    Multiset<int> values = new Multiset.from(cards
        .map((card) => card.value));
    Multiset<int> suits = new Multiset.from(cards
        .map((each) => each.suit));
    return new Hand._(cards, values, suits);
  }

  Hand._(this.cards, this.values, this.suits);

  int get rank {

    // Royal Flush: Ten, Jack, Queen, King, Ace, in same suit.
    if (suits.distinct.length == 1 &&
        cards[0].value == 8) {
      return rankFine(9, cards);
    }

    // Straight Flush: All cards are consecutive values of same suit.
    if (suits.distinct.length == 1 &&
        cards[0].value + 1 == cards[1].value &&
        cards[1].value + 1 == cards[2].value &&
        cards[2].value + 1 == cards[3].value &&
        cards[3].value + 1 == cards[4].value) {
      return rankFine(8, cards);
    }

    // Four of a Kind: Four cards of the same value.
    var fourOfAKind = cards.where((card) => values[card.value] == 4);
    if (fourOfAKind.length == 4) {
      return rankFine(7, fourOfAKind);
    }

    // Full House: Three of a kind and a pair.
    var twoOfAKind = cards.where((card) => values[card.value] == 2);
    var treeOfAKind = cards.where((card) => values[card.value] == 3);
    if (twoOfAKind.length == 2 && treeOfAKind.length == 3) {
      return rankFine(6, cards.where((card) => values[card.value] == 2 || values[card.value] == 3));
    }

    // Flush: All cards of the same suit.
    if (suits.distinct.length == 1) {
      return rankFine(5, cards);
    }

    // Straight: All cards are consecutive values.
    if (cards[0].value + 1 == cards[1].value &&
        cards[1].value + 1 == cards[2].value &&
        cards[2].value + 1 == cards[3].value &&
        cards[3].value + 1 == cards[4].value) {
      return rankFine(4, cards);
    }

    // Three of a Kind: Three cards of the same value.
    if (treeOfAKind.length == 3) {
      return rankFine(3, treeOfAKind);
    }

    // Two Pairs: Two different pairs.
    if (twoOfAKind.length == 4) {
      return rankFine(2, twoOfAKind);
    }

    // One Pair: Two cards of the same value.
    if (twoOfAKind.length == 2) {
      return rankFine(1, twoOfAKind);
    }

    // High Card: Highest value card.
    return rankFine(0, cards);

  }

  int rankFine(int base, Iterable<Card> cards) {
    var values = <int>[];
    values.add(base);
    //values.addAll(partition(cards.map((card) => card.value), 5, 0));
    return 0; //
  }

  @override
  String toString() => cards.toString();
}

void main() {
  var inputs = [
    '5H 5C 6S 7S KD        2C 3S 8S 8D TD',
    '5D 8C 9S JS AC        2C 5C 7D 8S QH',
    '2D 9C AS AH AC        3D 6D 7D TD QD',
    '4D 6S 9H QH QC        3D 6D 7H QD QS',
    '2H 2D 4C 4D 4S        3C 3D 3S 9S 9D',
  ];
  for (String input in inputs) {
    var cards = input.split(new RegExp('\\s+'))
        .map((each) => new Card(each));
    var hands = partition(cards, 5)
        .map((each) => new Hand(each));
    var ranks = hands.map((hand) => hand.rank);
    var winner = ranks.first == ranks.last ? 'Tie'
        : ranks.first > ranks.last ? 'Player 1'
        : 'Player 2';
    print('$input        $ranks        $winner');
  }
  assert(false);
}
