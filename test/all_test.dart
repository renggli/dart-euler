library euler.test.all_test;

import 'package:euler/euler.dart';
import 'package:test/test.dart';

void main() {
  for (var problem in problems) {
    test(
        'Problem ${problem.number}',
        () => problem.execute(arguments: ['--enable-asserts']).then((result) {
              if (result.exitCode != 0) {
                fail(result.stderr);
              }
              expect(result.exitCode, 0, reason: 'Exit code');
            }));
  }
}
