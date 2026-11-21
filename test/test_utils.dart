import 'dart:io';

import 'package:checks/checks.dart';

/// Extension on [Subject] of [ProcessResult] providing domain-specific checks.
extension ProcessResultChecks on Subject<ProcessResult> {
  /// Extracts the exit code.
  Subject<int> get exitCode => has('exitCode', (p) => p.exitCode);

  /// Extracts standard output.
  Subject<Object?> get stdout => has('stdout', (p) => p.stdout);

  /// Extracts standard error.
  Subject<Object?> get stderr => has('stderr', (p) => p.stderr);

  /// Asserts that the process completed successfully with exit code 0.
  void succeeded() => exitCode.equals(0);
}
