/**
 * Problem 17: Number letter counts
 *
 * If the numbers 1 to 5 are written out in words: one, two, three, four, five,
 * then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
 *
 * If all the numbers from 1 to 1000 (one thousand) inclusive were written out
 * in words, how many letters would be used?
 *
 * NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and
 * forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20
 * letters. The use of "and" when writing out numbers is in compliance with
 * British usage.
 */
library problem_017;

final cardinals = [ 'zero', 'one', 'two', 'three', 'four', 'five', 'six',
  'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen',
  'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen' ];
final decimals = [ 'zero', 'ten', 'twenty', 'thirty', 'forty', 'fifty', 'sixty',
  'seventy', 'eighty', 'ninety' ];

List<String> spell(int value) {
  if (value < cardinals.length) {
    return new List()
      ..add(cardinals[value]);
  } else if (value < 100) {
    if (value % 10 == 0) {
      return new List()
        ..add(decimals[value ~/ 10]);
    } else {
      return new List()
        ..add(decimals[value ~/ 10])
        ..add(cardinals[value % 10]);
    }
  } else if (value < 1000) {
    if (value % 100 == 0) {
      return new List()
        ..addAll(spell(value ~/ 100))
        ..add('hundred');
    } else {
      return new List()
        ..addAll(spell(value ~/ 100))
        ..addAll(['hundred', 'and'])
        ..addAll(spell(value % 100));
    }
  } else if (value < 1000000) {
    if (value % 1000 == 0) {
      return new List()
        ..addAll(spell(value ~/ 1000))
        ..add('thousand');
    } else {
      return new List()
        ..addAll(spell(value ~/ 1000))
        ..addAll(['thousand', 'and'])
        ..addAll(spell(value % 1000));
    }
  }
}

void main() {
  var total = 0;
  for (var i = 1; i <= 1000; i++) {
    total += spell(i).join('').length;
  }
  assert(total == 21124);
}
