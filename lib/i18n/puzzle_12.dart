import 'dart:io';

import 'package:collection/collection.dart';
import 'package:intl4x/intl4x.dart';
import 'package:more/more.dart';

class Entry {
  factory Entry.fromString(String input) {
    final parts = input.split(': ');
    final names = parts[0].split(', ');
    return Entry(family: names[0], first: names[1], phone: int.parse(parts[1]));
  }

  Entry({required this.family, required this.first, required this.phone});

  final String family;
  final String first;
  final int phone;

  @override
  String toString() => '$family, $first: ${phone.toString().padLeft(7, '0')}';
}

List<Entry> sortedEntries(
  Iterable<Entry> entries, {
  required String language,
  required String Function(Entry) keyOf,
}) => entries.sortedByCompare(
  keyOf,
  Intl(locale: Locale(language: language)).collation().compare,
);

int run(String filename) {
  final entries = File(filename).readAsLinesSync().map(Entry.fromString);
  final english = sortedEntries(
    entries,
    language: 'en',
    keyOf:
        (entry) =>
            UnicodeCharMatcher.letter()
                .retainFrom(entry.family.replaceAll('Æ', 'ae'))
                .toLowerCase(),
  );
  final swedish = sortedEntries(
    entries,
    language: 'sv',
    keyOf:
        (entry) => UnicodeCharMatcher.letter().retainFrom(
          entry.family.replaceAll('Æ', 'Ä').replaceAll('Ø', 'Ö'),
        ),
  );
  final dutch = sortedEntries(
    entries,
    language: 'nl',
    keyOf:
        (entry) => entry.family.removePrefix(
          entry.family.takeTo(UnicodeCharMatcher.letterUppercase()),
        ),
  );
  final middle = entries.length ~/ 2;
  return english[middle].phone * swedish[middle].phone * dutch[middle].phone;
}

void main() {
  assert(run('lib/i18n/puzzle_12_test.txt') == 1885816494308838);
  assert(run('lib/i18n/puzzle_12_input.txt') == 5722005348122931);
}
