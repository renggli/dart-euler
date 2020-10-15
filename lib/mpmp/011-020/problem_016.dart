/// MPMP16: What percentage of numbers in the first 128 rows of Pascal's
/// Triangle are odd?
///
/// http://www.think-maths.co.uk/pascaltriangle
import 'package:more/math.dart';

void main() {
  var total = 0, odd = 0;
  for (var r = 0; r <= 128; r++) {
    final row = BigInt.from(r);
    for (var c = 0; c <= r; c++) {
      final col = BigInt.from(c);
      final value = row.binomial(col);
      if (value.isOdd) {
        odd++;
      }
      total++;
    }
  }
  final percentage = 100.0 / total * odd;
  assert(percentage == 26.10614192009541);
}
