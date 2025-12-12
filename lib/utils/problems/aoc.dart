import 'dart:io';

import 'package:more/more.dart';

import '../problem.dart';
import '../results.dart';
import '../runner.dart';

/// Encapsulates an Advent of Code puzzle.
class AoC extends Problem {
  AoC({
    required int year,
    required int day,
    int? part1,
    int? part2,
    bool skip2 = false,
    Iterable<AoCExample> examples = const [],
  }) : _year = year,
       _day = day,
       _part1 = part1,
       _part2 = part2,
       _skip2 = skip2,
       _examples = examples.toList(growable: false),
       super(label: 'Advent of Code $year, Day $day');

  final int _year, _day;
  final int? _part1, _part2;
  final bool _skip2;
  final List<AoCExample> _examples;

  @override
  Future<void> run(Runner runner) async {
    // Fetch puzzle input.
    final puzzleFile = await _downloadFile(
      year: _year,
      day: _day,
      filename: 'input.txt',
      url: 'https://adventofcode.com/$_year/day/$_day/input',
      contentType: ContentType.text.value,
    );
    final puzzleInput = (await puzzleFile.readAsString()).removeSuffix('\n');

    // Part 1 (examples)
    for (var i = 0; i < _examples.length; i++) {
      final example = _examples[i];
      if (example.part1 != null) {
        runner.addResult(
          await Result.run<int>(
            'Part 1 - ${example.label ?? 'Example ${i + 1}'}',
            () => part1(example.input),
            expected: example.part1,
          ),
        );
      }
    }
    // Part 1 (puzzle)
    runner.addResult(
      await Result.run<int>(
        'Part 1',
        () => part1(puzzleInput),
        expected: _part1,
      ),
    );

    // Part 2 (examples)
    if (_skip2) return;
    for (var i = 0; i < _examples.length; i++) {
      final example = _examples[i];
      if (example.part2 != null) {
        runner.addResult(
          await Result.run<int>(
            'Part 2 - ${example.label ?? 'Example ${i + 1}'}',
            () => part2(example.input),
            expected: example.part2,
          ),
        );
      }
    }
    // Part 2 (puzzle)
    runner.addResult(
      await Result.run<int>(
        'Part 2',
        () => part2(puzzleInput),
        expected: _part2,
      ),
    );
  }

  /// Implementation of part 1.
  int part1(String input) => throw UnimplementedError('Part 1 not solved yet.');

  /// Implementation of part 2.
  int part2(String input) => throw UnimplementedError('Part 2 not solved yet.');
}

/// Encapsulates an Advent of Code example.
class AoCExample {
  AoCExample({this.label, required this.input, this.part1, this.part2});

  final String? label;
  final String input;
  final int? part1;
  final int? part2;
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
