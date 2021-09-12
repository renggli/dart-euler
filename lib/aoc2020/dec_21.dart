import 'dart:io';

import 'package:collection/collection.dart';
import 'package:more/more.dart';

final lines = File('lib/aoc2020/dec_21.txt')
    .readAsLinesSync()
    .map((line) => line.removeSuffix(')').split(' (contains '));

void main() {
  final ingredients = <String>[];
  final allergens = SetMultimap<String, String>();
  for (final pair in lines) {
    final ingredientLine = pair.first.split(' ').toSet();
    final allergenLine = pair.last.split(', ').toSet();
    ingredients.addAll(ingredientLine);
    for (final allergen in allergenLine) {
      allergens.replaceAll(
          allergen,
          allergens[allergen].isEmpty
              ? ingredientLine
              : allergens[allergen].intersection(ingredientLine));
    }
  }

  final ingredientToAllergen = BiMap<String, String>();
  while (allergens.isNotEmpty) {
    final entry = allergens
        .asMap()
        .entries
        .firstWhere((entry) => entry.value.length == 1);
    final allergen = entry.key;
    final ingredient = entry.value.single;
    ingredientToAllergen[allergen] = ingredient;
    for (final keyValue in allergens.asMap().entries.toList()) {
      keyValue.value.remove(ingredient);
    }
    allergens.removeAll(allergen);
  }

  assert(ingredients
          .where((each) => !ingredientToAllergen.containsValue(each))
          .length ==
      1885);
  assert(ingredientToAllergen.values
          .toList()
          .sortedBy<String>((each) => ingredientToAllergen.backward[each]!)
          .join(',') ==
      'fllssz,kgbzf,zcdcdf,pzmg,kpsdtv,fvvrc,dqbjj,qpxhfp');
}
