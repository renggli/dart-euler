import 'dart:io';

import 'package:args/args.dart';
import 'package:more/functional.dart';
import 'package:more/math.dart';

final session = File('bin/.session').also((file) {
  if (!file.existsSync()) {
    stderr.writeln('$file does not exist');
    exit(1);
  }
  return file.readAsStringSync();
});

final argParser = ArgParser()
  ..addOption(
    'day',
    abbr: 'd',
    help: 'day of the month (defaults to today)',
  )
  ..addOption(
    'year',
    abbr: 'y',
    help: 'day of the year (defaults to this year)',
  );

Never printUsage() {
  stdout.writeln('Usage: aoc [options]');
  stdout.writeln();
  stdout.writeln(argParser.usage);
  exit(1);
}

Future<void> main(List<String> arguments) async {
  // Parse the arguments.
  final now = DateTime.now();
  final args = argParser.parse(arguments);
  final year = int.tryParse(args.option('year') ?? '') ?? now.year;
  final day = int.tryParse(args.option('day') ?? '') ?? now.day;
  final date = DateTime(year, DateTime.december, day);

  // Validate the params.
  if (!year.between(2015, now.year)) {
    stderr.writeln('invalid year: $date');
    exit(1);
  }
  if (!day.between(1, 25) || !date.isBefore(now)) {
    stderr.writeln('invalid day: $date');
    exit(2);
  }

  final path = 'lib/aoc/$year/dec_${day.toString().padLeft(2, '0')}';

  // Download the puzzle input.
  final dataFile = File('$path.txt');
  if (!await dataFile.exists()) {
    final url = Uri.parse('https://adventofcode.com/$year/day/$day/input');
    stdout.writeln('Downloading $url ...');
    final request = await HttpClient().getUrl(url);
    request.cookies.add(Cookie('session', session));
    request.headers.add('CONTENT_TYPE', 'text/plain');
    final response = await request.close();
    await response.pipe(dataFile.openWrite());
  }

  // Generate dart template.
  final dartFile = File('$path.dart');
  if (!await dartFile.exists()) {
    stdout.writeln('Creating $path.dart ...');
    final out = dartFile.openWrite();
    out.writeln('import \'dart:io\';');
    out.writeln('import \'dart:math\';');
    out.writeln();
    out.writeln('import \'package:data/data.dart\';');
    out.writeln('import \'package:more/more.dart\';');
    out.writeln();
    out.writeln('final input = File(\'$path.txt\').readAsLinesSync();');
    out.writeln();
    out.writeln('int problem1() => 0;');
    out.writeln('int problem2() => 0;');
    out.writeln();
    out.writeln('void main() {');
    out.writeln('  print(\'Problem 1: \${problem1()}\');');
    out.writeln('  print(\'Problem 2: \${problem2()}\');');
    out.writeln('}');
    await out.close();
  }

  // Format the dart template.
  await Process.run('dart', ['format', '--fix', dartFile.absolute.path]);
}
