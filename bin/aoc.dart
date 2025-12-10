import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:more/more.dart';

import 'utils/ansi.dart';
import 'utils/string.dart';

final now = DateTime.now().truncateTo(TimeUnit.day);
final argParser = ArgParser()
  ..addFlag('help', abbr: '?', hide: true)
  ..addOption(
    'year',
    abbr: 'y',
    defaultsTo: now.year.toString(),
    help: 'year of advent of code',
    allowed: (2015.to(now.year + 1).map((year) => '$year')),
  )
  ..addOption(
    'day',
    abbr: 'd',
    defaultsTo: now.day.toString(),
    help: 'day of advent of code',
    allowed: (1.to(25).map((day) => '$day')),
  )
  ..addMultiOption(
    'solve',
    abbr: 's',
    help: 'solve the puzzle parts',
    allowed: ['1', '2'],
  )
  ..addMultiOption(
    'answer',
    abbr: 'a',
    help: 'answer the puzzle parts',
    allowed: ['1', '2'],
  );

void printUsage() {
  stdout.writeln('Usage: aoc [options]');
  stdout.writeln();
  stdout.writeln(argParser.usage);
}

final sessionCookie = File('bin/.session').also((file) {
  if (!file.existsSync()) {
    stderr.writeln('$file does not exist');
    exit(1);
  }
  return file.readAsStringSync().trim();
});

String getBaseUrl({required int year, required int day}) =>
    'https://adventofcode.com/$year/day/$day';

String getBaseName({required int year, required int day}) =>
    'lib/aoc/$year/dec_${day.toString().padLeft(2, '0')}';

File getPuzzle({required int year, required int day}) =>
    File('${getBaseName(year: year, day: day)}.html');

File getPuzzleInput({required int year, required int day}) =>
    File('${getBaseName(year: year, day: day)}.txt');

File getPuzzlePart({required int year, required int day, required int part}) =>
    File('${getBaseName(year: year, day: day)}_$part.md');

File getImplementation({required int year, required int day}) =>
    File('${getBaseName(year: year, day: day)}.dart');

Future<List<File>> downloadPuzzle({required int year, required int day}) async {
  final file = getPuzzle(year: year, day: day);
  if (!await file.exists()) {
    final url = Uri.parse(getBaseUrl(year: year, day: day));
    stdout.writeln('${bold}Downloading puzzle$reset $url ...');
    final client = HttpClient();
    try {
      final request = await client.getUrl(url);
      request.cookies.add(Cookie('session', sessionCookie));
      request.headers.add('CONTENT_TYPE', 'text/html');
      final response = await request.close();
      await file.create(recursive: true);
      final sink = file.openWrite();
      await response.pipe(sink);
      await sink.close();
    } finally {
      client.close();
    }
  }
  final content = await file.readAsString();
  final matcher = RegExp(
    r'<article class="day-desc">(.*?)</article>',
    dotAll: true,
  );
  final parts = matcher
      .allMatches(content)
      .map((match) => match.group(1)!)
      .toList();
  final files = <File>[];
  for (var i = 0; i < parts.length; i++) {
    final file = getPuzzlePart(year: year, day: day, part: i + 1);
    if (!await file.exists()) {
      stdout.write('${bold}Extracting part ${i + 1}$reset ${file.path} ...');
      await file.create(recursive: true);
      await file.writeAsString(parts[i].toMarkdown());
    }
    files.add(file);
  }
  return files;
}

Future<File> downloadPuzzleInput({required int year, required int day}) async {
  final file = getPuzzleInput(year: year, day: day);
  if (!await file.exists()) {
    final url = Uri.parse('${getBaseUrl(year: year, day: day)}/input');
    stdout.writeln('${bold}Downloading puzzle input ...$reset');
    final client = HttpClient();
    try {
      final request = await client.getUrl(url);
      request.cookies.add(Cookie('session', sessionCookie));
      request.headers.add('CONTENT_TYPE', 'text/plain');
      final response = await request.close();
      await file.create(recursive: true);
      await response.pipe(file.openWrite());
    } finally {
      client.close();
    }
  }
  return file;
}

Future<File> createTemplate({
  required int year,
  required int day,
  required File input,
}) async {
  final file = getImplementation(year: year, day: day);
  if (!await file.exists()) {
    stdout.writeln('${bold}Creating template ...$reset');
    final out = file.openWrite();
    out.writeln('import \'dart:io\';');
    out.writeln('import \'dart:math\';');
    out.writeln();
    out.writeln('import \'package:data/data.dart\';');
    out.writeln('import \'package:more/more.dart\';');
    out.writeln();
    out.writeln('final exampleInput = <String>[];');
    out.writeln(
      'final puzzleInput = File(\'${input.path}\').readAsLinesSync();',
    );
    out.writeln();
    out.writeln('int part1(List<String> data) { return 0; }');
    out.writeln();
    out.writeln('int part2(List<String> data) { return 0; }');
    out.writeln();
    out.writeln('void main() {');
    out.writeln('  print(\'Part 1 (Example): \${part1(exampleInput)}\');');
    out.writeln('  print(\'Part 1 (Puzzle): \${part1(puzzleInput)}\');');
    out.writeln('  print(\'\');');
    out.writeln('  print(\'Part 2 (Example): \${part2(exampleInput)}\');');
    out.writeln('  print(\'Part 2 (Puzzle): \${part2(puzzleInput)}\');');
    out.writeln('}');
    await out.close();
    await Process.run('dart', ['format', file.absolute.path]);
  }
  return file;
}

Future<void> streamListener(
  Stream<List<int>> stream,
  void Function(String) callback,
) {
  final completer = Completer<void>();
  stream
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen(
        callback,
        onError: completer.completeError,
        onDone: completer.complete,
        cancelOnError: true,
      );
  return completer.future;
}

Future<void> runGemini(String prompt) async {
  stdout.writeln('${bold}Prompting Gemini ...$reset');
  stdout.writeln(prompt);
  stdout.writeln('${bold}Gemini is thinking ...$reset');
  final process = await Process.start('gemini', [
    '--output-format=text',
    '--yolo',
    prompt,
  ]);
  await Future.wait([
    streamListener(process.stdout, stdout.writeln),
    streamListener(process.stderr, stderr.writeln),
  ]);
}

Future<void> submitAnswer({
  required int year,
  required int day,
  required int part,
}) async {
  final file = getImplementation(year: year, day: day);
  final contents = await file.readAsString();
  final solution = RegExp(
    'assert\\(part$part\\(.*puzzleInput.*\\)\\s*==\\s*(\\d+)\\);',
  ).firstMatch(contents)?.group(1);
  if (solution == null) {
    stderr.writeln('Could not find solution in ${file.path} for part $part.');
    exit(1);
  }
  stdout.writeln('${bold}Submitting answer $solution for part $part ...$reset');
  final url = Uri.parse('${getBaseUrl(year: year, day: day)}/answer');
  final body = 'level=$part&answer=$solution';
  final client = HttpClient();
  try {
    final request = await client.postUrl(url);
    request.cookies.add(Cookie('session', sessionCookie));
    request.headers.contentType = ContentType.parse(
      'application/x-www-form-urlencoded',
    );
    request.headers.contentLength = body.length;
    request.add(utf8.encode(body));
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      stderr.writeln('Failed to submit answer: ${response.statusCode}');
      exit(1);
    }
    await response.drain(null);
    if (part == 1) {
      await getPuzzle(year: year, day: day).delete();
    }
  } finally {
    client.close();
  }
}

Future<void> main(List<String> arguments) async {
  // Parse the arguments.
  final args = argParser.parse(arguments);
  if (args.wasParsed('help')) {
    printUsage();
    exit(1);
  }
  final year = int.parse(args.option('year')!);
  final day = int.parse(args.option('day')!);

  // Prepare the data.
  final input = await downloadPuzzleInput(year: year, day: day);
  final dart = await createTemplate(year: year, day: day, input: input);

  // Prepare to auto-solve.
  if (!args.wasParsed('solve') && !args.wasParsed('answer')) exit(0);
  final solve = args.multiOption('solve').map(int.parse).toSet();
  final answer = args.multiOption('answer').map(int.parse).toSet();

  // Solve the puzzle part by part.
  for (var part = 1; part <= 2; part++) {
    final puzzles = await downloadPuzzle(year: year, day: day);
    if (part > puzzles.length) {
      stderr.writeln('Part $part is not available (yet).');
      exit(1);
    }
    if (solve.contains(part)) {
      final buffer = StringBuffer();
      buffer.writeln('You are solving AoC $year day $day part $part.');
      for (var p = 0; p < 2; p++) {
        buffer.writeln(
          'The puzzle for part ${p + 1} is '
          '${p < puzzles.length ? 'in @${puzzles[p].path}' : 'not yet known'}'
          '.',
        );
      }
      buffer.writeln(
        'The puzzle input is in ${input.path} (do not attempt to directly read '
        'the whole file into your context, as it might be very large).',
      );
      buffer.writeln('Your solution should be in @${dart.path}.');
      buffer.writeln();
      buffer.writeln('Refine the code to solve the puzzle:');
      buffer.writeln('- Read the puzzle description carefully.');
      buffer.writeln(
        '- Reproduce the example from the puzzle description, '
        'do not create unit tests.',
      );
      buffer.writeln('- Write readable, efficient, and idiomatic Dart code.');
      if (part == 2) {
        buffer.writeln('- Avoid duplicating code between part 1 and 2.');
      }
      buffer.writeln('- Run `dart run ${dart.path}` to verify your solution.');
      buffer.writeln('- Run `dart analyze ${dart.path}` to check for errors.');
      buffer.writeln();
      buffer.writeln(
        'Once the solution is verified, replace the print statements '
        'for part $part with assertions of the form: '
        '`assert(part$part(exampleInput) == EXAMPLE_SOLUTION)` and '
        '`assert(part$part(puzzleInput) == PUZZLE_SOLUTION)`.',
      );
      await runGemini(buffer.toString());
    }
    if (answer.contains(part)) {
      await submitAnswer(year: year, day: day, part: part);
    }
  }

  // Cleanup the code.
  await Process.run('dart', ['fix', '--apply', dart.path]);
  await Process.run('dart', ['format', dart.path]);
}
