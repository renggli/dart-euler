/// Problem 31: Coin sums
///
/// In England the currency is made up of pound, £, and pence, p, and there are
/// eight coins in general circulation:
///
///    1p, 2p, 5p, 10p, 20p, 50p, £1 (100p) and £2 (200p).
///
/// It is possible to make £2 in the following way:
///
///    1 £1 + 1 50p + 2 20p + 1 5p + 1 2p + 3 1p
///
/// How many different ways can £2 be made using any number of coins?
const List<int> coins = [1, 2, 5, 10, 20, 50, 100, 200];
const int target = 200;

int count(int index, int target) {
  if (target == 0) {
    return 1;
  }
  if (index == coins.length) {
    return 0;
  }
  var tally = 0;
  for (var i = 0; i <= target ~/ coins[index]; i++) {
    tally += count(index + 1, target - i * coins[index]);
  }
  return tally;
}

void main() {
  assert(count(0, target) == 73682);
}
