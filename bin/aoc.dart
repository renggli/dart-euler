import 'dart:io';

import 'package:args/args.dart';
import 'package:more/functional.dart';
import 'package:more/math.dart';
import 'package:more/printer.dart';
import 'package:more/temporal.dart';

final session = File('bin/.session').also((file) {
  if (!file.existsSync()) {
    stderr.writeln('$file does not exist');
    exit(1);
  }
  return file.readAsStringSync();
});

final now = DateTime.now().truncateTo(TimeUnit.day);
final dateFormatter = DateTimePrinter.date();
final argParser =
    ArgParser()
      ..addFlag('help', abbr: '?', hide: true)
      ..addOption(
        'date',
        abbr: 'd',
        defaultsTo: dateFormatter.print(now),
        help: 'date in the format YYYY-MM-DD',
      );

void printUsage() {
  stdout.writeln('Usage: aoc [options]');
  stdout.writeln();
  stdout.writeln(argParser.usage);
}

Future<void> main(List<String> arguments) async {
  // Parse the arguments.
  final args = argParser.parse(arguments);
  final date = DateTime.parse(args.option('date')!).truncateTo(TimeUnit.day);

  // Asking for help.
  if (args.wasParsed('help')) {
    printUsage();
    exit(1);
  }

  // Validate the date.
  if (!date.year.between(2015, now.year)) {
    stderr.writeln('invalid year: ${dateFormatter.print(date)}');
    exit(2);
  }
  if (date.month != DateTime.december) {
    stderr.writeln('invalid month: ${dateFormatter.print(date)}');
    exit(3);
  }
  if (!date.day.between(1, 25)) {
    stderr.writeln('invalid day: ${dateFormatter.print(date)}');
    exit(4);
  }
  if (date.isAfter(now)) {
    stderr.writeln('invalid date: ${dateFormatter.print(date)}');
    exit(5);
  }

  // Define helper constants.
  final base = 'lib/aoc/${date.year}';
  final path = '$base/dec_${date.day.toString().padLeft(2, '0')}';
  final url = 'https://adventofcode.com/${date.year}/day/${date.day}';

  // Download the puzzle input.
  final dataFile = File('$path.txt');
  if (!await dataFile.exists()) {
    final inputUrl = Uri.parse('$url/input');
    stdout.writeln('Downloading $inputUrl ...');
    final request = await HttpClient().getUrl(inputUrl);
    request.cookies.add(Cookie('session', session));
    request.headers.add('CONTENT_TYPE', 'text/plain');
    final response = await request.close();
    await dataFile.create(recursive: true);
    await response.pipe(dataFile.openWrite());
  }

  // Create an empty example file.
  final exampleFile = File('$base/.example.txt');
  final out = exampleFile.openWrite();
  await out.close();

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
    out.writeln(
      'final input = File(\'$base/.example.txt\').readAsLinesSync();',
    );
    out.writeln('// final input = File(\'$path.txt\').readAsLinesSync();');
    out.writeln();
    out.writeln('int problem1() { return 0; }');
    out.writeln();
    out.writeln('int problem2() { return 0; }');
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
