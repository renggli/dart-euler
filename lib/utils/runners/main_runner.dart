import 'dart:async';
import 'dart:io';

import 'package:ansi_escape_codes/ansi_escape_codes.dart';
import 'package:more/more.dart' show TimeUnit;
import 'package:more/printer.dart';

import '../group.dart';
import '../problem.dart';
import '../results.dart';
import '../runner.dart';

/// A runner that runs problems in the main program.
class MainRunner implements Runner {
  var _level = 0;

  @override
  Future<void> runGroup(Group group) async {
    stdout.writeln(_titlePrinter('  ${'  ' * _level}${group.label}'));
    _level++;
    try {
      for (final group in group.subgroups) {
        await runGroup(group);
      }
      for (final problem in group.problems) {
        await runProblem(problem);
      }
    } finally {
      _level--;
    }
  }

  @override
  Future<void> runProblem(Problem problem) async {
    stdout.writeln(_titlePrinter('  ${'  ' * _level}${problem.label}'));
    _level++;
    try {
      await problem.run(this);
    } finally {
      _level--;
    }
  }

  @override
  void addResult(Result result) {
    final (verdictColor, verdictChar) = switch (result) {
      Verified() => (fg256HighGreen, '✓'),
      Unverified() => (fg256HighBlue, '?'),
      Mismatch() => (fg256HighYellow, '!'),
      Failure() => (fg256HighRed, '✖'),
    };
    final message = switch (result) {
      Verified(actual: final actual) => actual.toString(),
      Unverified(actual: final actual) => actual.toString(),
      Mismatch(actual: final actual, expected: final expected) =>
        '$actual != $expected',
      Failure(error: final error) => Error.safeToString(error),
    };
    stdout.write('$verdictColor${_verdictPrinter(verdictChar)}$reset');
    stdout.write(_labelPrinter('${'  ' * _level}${result.label}'));
    stdout.write(_messagePrinter(message));
    stdout.write(_benchmarkPrinter(result.duration));
    stdout.writeln();
    if (result case Failure(stackTrace: final stackTrace)) {
      stderr.writeln(stackTrace);
    }
  }
}

const _defaultTerminalWidth = 100;
final _terminalWidth = stdout.hasTerminal
    ? stdout.terminalColumns
    : _defaultTerminalWidth;

const _verdictWidth = 2;
final _labelWidth = _terminalWidth ~/ 2 - _verdictWidth - 1;
final _messageWidth =
    _terminalWidth - _labelWidth - _verdictWidth - _benchmarkWidth - 2;
final _benchmarkWidth = _terminalWidth < 80 ? 0 : 11;

final _titlePrinter = const Printer<String>.standard()
    .truncateRight(_terminalWidth)
    .around(bold, reset);
final _verdictPrinter = const Printer<String>.standard()
    .around(bold, reset)
    .after(' ');
final _labelPrinter = const Printer<String>.standard()
    .truncateRight(_labelWidth)
    .padRight(_labelWidth)
    .after(' ');
final _messagePrinter = const Printer<String>.standard()
    .truncateRight(_messageWidth)
    .padRight(_messageWidth)
    .after(' ');
final _benchmarkPrinter = DurationPrinter(
  (builder) => builder
    ..part(TimeUnit.millisecond, printer: FixedNumberPrinter<int>().padLeft(5))
    ..literal('.')
    ..part(TimeUnit.microsecond, printer: FixedNumberPrinter<int>(padding: 3))
    ..literal('ms'),
).truncateLeft(_benchmarkWidth).padLeft(_benchmarkWidth);
