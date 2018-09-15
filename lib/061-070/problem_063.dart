/// Problem 63: Powerful digit counts
///
/// The 5-digit number, 16807=7^5, is also a fifth power. Similarly, the 9-digit number,
/// 134217728=8^9, is a ninth power.
///
/// How many n-digit positive integers exist which are also an n-th power?
library euler.problem_063;

void main() {
  var count = 0;
  for (var a = BigInt.one; a < BigInt.from(25); a += BigInt.one) {
    for (var b = 1; b < 25; b++) {
      var len = a.pow(b).toString().length;
      if (len == b) {
        count++;
      } else if (len > b) {
        break;
      }
    }
  }
  assert(count == 49);
}
