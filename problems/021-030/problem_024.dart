/**
 * Problem 24: Lexicographic permutations
 *
 * A permutation is an ordered arrangement of objects. For example, 3124 is one
 * possible permutation of the digits 1, 2, 3 and 4. If all of the permutations
 * are listed numerically or alphabetically, we call it lexicographic order.
 * The lexicographic permutations of 0, 1 and 2 are:
 *
 *   012   021   102   120   201   210
 *
 * What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4,
 * 5, 6, 7, 8 and 9?
 */
library problem_024;

import 'dart:collection';

void nextPermutation(List list) {
  // Find the largest index k such that a[k] < a[k + 1]. If no such index
  // exists, the permutation is the last permutation.
  var k = list.length - 2;
  while (k >= 0 && list[k] >= list[k + 1]) {
    k--;
  }
  if (k == -1) {
    return;
  }

  // Find the largest index l such that a[k] < a[l]. Since k + 1 is such an
  // index, l is well defined and satisfies k < l.
  var l = list.length - 1;
  while (list[k] >= list[l]) {
    l--;
  }

  // Swap a[k] with a[l].
  _swap(list, k, l);

  // Reverse the sequence from a[k + 1] up to and including the final element
  // a[n].
  for (var i = k + 1, j = list.length - 1; i < j; i++, j--) {
    _swap(list, i, j);
  }
}

void _swap(List list, int i, int j) {
  var temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}

var ith = 1000000;

void main() {
  var list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  for (var i = 1; i < ith; i++) {
    nextPermutation(list);
  }
  assert(list.join() == '2783915460');
}
