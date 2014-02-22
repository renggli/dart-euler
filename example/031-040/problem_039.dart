/**
 * Problem 39: Integer right triangles
 *
 * If p is the perimeter of a right angle triangle with integral length sides,
 * {a,b,c}, there are exactly three solutions for p = 120.
 *
 *   {20,48,52}, {24,45,51}, {30,40,50}
 *
 * For which value of p <= 1000, is the number of solutions maximised?
 */
library problem_039;

void main() {
  var mp = 0, mpc = 0;
  for (var p = 1; p <= 1000; p++) {
    var pc = 0;
    for (var a = 1; a <= p - 2; a++) {
      for (var b = a; b <= p - a - 1; b++) {
        var c = p - a - b;
        if (a * a + b * b == c * c) {
          pc++;
        }
      }
    }
    if (pc > mpc) {
      mpc = pc;
      mp = p;
    }
  }
  assert(mp == 840);
}
