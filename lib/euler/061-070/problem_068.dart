// Problem 68: Magic 5-gon ring
//
// Consider the following "magic" 3-gon ring, filled with the numbers 1 to 6,
// and each line adding to nine.
//
// Working clockwise, and starting from the group of three with the numerically
// lowest external node (4,3,2 in this example), each solution can be described
// uniquely. For example, the above solution can be described by the set: 4,3,2;
// 6,2,1; 5,1,3.
//
// It is possible to complete the ring with four different totals: 9, 10, 11,
// and 12. There are eight solutions in total.
//
//    Total     Solution Set
//    9         4,2,3; 5,3,1; 6,1,2
//    9         4,3,2; 6,2,1; 5,1,3
//    10        2,3,5; 4,5,1; 6,1,3
//    10        2,5,3; 6,3,1; 4,1,5
//    11        1,4,6; 3,6,2; 5,2,4
//    11        1,6,4; 5,4,2; 3,2,6
//    12        1,5,6; 2,6,4; 3,4,5
//    12        1,6,5; 3,5,4; 2,4,6
//
// By concatenating each group it is possible to form 9-digit strings; the
// maximum string for a 3-gon ring is 432621513.
//
// Using the numbers 1 to 10, and depending on arrangements, it is possible to
// form 16- and 17-digit strings. What is the maximum 16-digit string for a
// "magic" 5-gon ring?

import 'package:more/collection.dart';

void main() {
  var maxString = '';

  for (final p in [1, 2, 3, 4, 5].permutations()) {
    final outer = <int>[];
    var valid = true;
    for (var i = 0; i < 5; i++) {
      final o = 14 - p[i] - p[(i + 1) % 5];
      if (o < 6 || o > 10 || outer.contains(o)) {
        valid = false;
        break;
      }
      outer.add(o);
    }
    if (valid) {
      var minIndex = 0;
      for (var i = 1; i < 5; i++) {
        if (outer[i] < outer[minIndex]) {
          minIndex = i;
        }
      }

      final buffer = StringBuffer();
      for (var i = 0; i < 5; i++) {
        final idx = (minIndex + i) % 5;
        buffer.write(outer[idx]);
        buffer.write(p[idx]);
        buffer.write(p[(idx + 1) % 5]);
      }

      final s = buffer.toString();
      if (maxString.isEmpty || s.compareTo(maxString) > 0) {
        maxString = s;
      }
    }
  }

  assert(maxString == '6531031914842725');
}
