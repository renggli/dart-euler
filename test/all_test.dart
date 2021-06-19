import 'package:euler/all.dart';
import 'package:test/test.dart';

void main() {
  for (final problem in problems) {
    test(
        problem.label,
        () => problem.execute().then((result) {
              if (result.exitCode != 0) {
                fail(result.stderr);
              }
              expect(result.exitCode, 0, reason: 'Exit code');
            }));
  }
}
