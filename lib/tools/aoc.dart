import 'dart:io';

import 'package:more/collection.dart';
import 'package:more/functional.dart';

import 'expectations.dart';
import 'problem.dart';

/// Advent of Code.
class AoC extends Problem {
  const AoC({
    required this.year,
    required this.day,
    required this.part,
    this.expected,
    this.examples = const [],
  });

  /// The year of the problem.
  final int year;

  /// The day of the problem.
  final int day;

  /// The part of the problem.
  final int part;

  /// The expected result of the problem.
  final int? expected;

  /// Additional examples given in the problem description.
  final List<Expectation> examples;

  @override
  String get label => 'AoC $year Day $day Part $part';

  @override
  Stream<Expectation> get expectations async* {
    for (final example in examples) {
      yield example;
    }
    yield AocExpectation(year: year, day: day, expected: expected);
  }
}

/// Advent of Code expectation.
class AocExpectation extends Expectation {
  const AocExpectation({required this.year, required this.day, super.expected})
    : super(label: 'Answer');

  /// The year of the problem.
  final int year;

  /// The day of the problem.
  final int day;

  @override
  Future<String> get input async {
    final file = await _downloadFile(
      year: year,
      day: day,
      filename: 'input.txt',
      url: 'https://adventofcode.com/$year/day/$day/input',
      contentType: 'text/plain',
    );
    final contents = await file.readAsString();
    return contents.removeSuffix('\n');
  }
}

final _sessionCookie =
    Platform.environment['AOC_SESSION_COOKIE'] ??
    File('.cache/aoc/session_cookie.txt').also<String>((file) {
      if (file.existsSync()) return file.readAsStringSync().trim();
      throw StateError('$file does not exist');
    });

Future<File> _downloadFile({
  required int year,
  required int day,
  required String filename,
  required String url,
  required String contentType,
}) async {
  final file = File(
    '.cache/aoc/$year/${day.toString().padLeft(2, '0')}/$filename',
  );
  if (!await file.exists()) {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      request.cookies.add(Cookie('session', _sessionCookie));
      request.headers.add(HttpHeaders.contentTypeHeader, contentType);
      final response = await request.close();
      await file.create(recursive: true);
      final sink = file.openWrite();
      await response.pipe(sink);
    } finally {
      client.close();
    }
  }
  return file;
}
