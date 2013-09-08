/**
 * Problem 62: Cubic permutations
 *
 * The cube, 41063625 (345^3), can be permuted to produce two other cubes: 56623104 (384^3) and
 * 66430125 (405^3). In fact, 41063625 is the smallest cube which has exactly three permutations
 * of its digits which are also cube.
 *
 * Find the smallest cube for which exactly five permutations of its digits are cube.
 */
library problem_062;

void main() {
  var cubes = new Map();
  for (var base = 0; base < 1000; base++) {
    var value = base * base * base;
    var key = new String.fromCharCodes(value.toString().codeUnits..sort());
    cubes.putIfAbsent(key, () => new List()).add(value);
  }
  var candidates = new List();
  for (var values in cubes.values) {
    if (values.length == 5) {
      candidates.addAll(values);
    }
  }
  candidates.sort();
  print(candidates);
  assert(false);
}


//    print min([min(v) for k, v in cubes.items() if len(v) == 5])