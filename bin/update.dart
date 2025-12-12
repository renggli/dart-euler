import 'dart:io';

import 'package:collection/collection.dart';
import 'package:more/collection.dart';

final targetFile = File('lib/all.dart');
final filePattern = RegExp(r'(.*_\d+)\.dart$');
final problemPattern = RegExp(
  r'class\s+(\w+)\s+(extends|implements|with).*(\b(AoC|Euler|I18n)\b).*\{\n',
  caseSensitive: true,
);

Iterable<Directory> listDirectories(Directory directory) =>
    directory.listSync().whereType<Directory>().where(
      (directory) =>
          listDirectories(directory).isNotEmpty ||
          listProblems(directory).isNotEmpty,
    );

Iterable<File> listProblems(Directory directory) => directory
    .listSync()
    .whereType<File>()
    .where((file) => file.path.contains(filePattern));

Future<void> createGroup(
  List<String> imports,
  List<String> definitions,
  Directory directory,
) async {
  final label = directory.path
      .takeLastTo('/')
      .replaceAll('_', ' ')
      .toUpperCaseFirstCharacter();
  definitions.add('Group(');
  definitions.add('label: \'$label\',');

  final directories = listDirectories(directory).sortedBy((dir) => dir.path);
  if (directories.isNotEmpty) {
    definitions.add('subgroups: [');
    for (final directory in directories) {
      await createGroup(imports, definitions, directory);
      definitions.add(',');
    }
    definitions.add('],');
  }

  final problems = listProblems(directory).sortedBy((file) => file.path);
  if (problems.isNotEmpty) {
    definitions.add('problems: [');
    for (final file in problems) {
      if (file.path.endsWith('2025/dec_01.dart')) {
        print('foo');
      }
      final contents = file.readAsStringSync();
      final name = problemPattern.firstMatch(contents)?.group(1) ?? '';
      if (name.isNotEmpty) {
        definitions.add('$name(),');
        final relativePath = file.absolute.path.skip(
          targetFile.parent.absolute.path.length + 1,
        );
        imports.add('import \'$relativePath\';');
      } else {
        stderr.writeln('Could not find problem class in ${file.path}');
      }
    }
    definitions.add('],');
  }
  definitions.add(')');
}

Future<void> main() async {
  final imports = <String>['import \'utils.dart\';'];
  final definitions = <String>['final all ='];
  await createGroup(imports, definitions, targetFile.parent);
  definitions.add(';');

  final out = targetFile.openWrite();
  out.writeAll(imports, '\n');
  out.write('\n\n');
  out.writeAll(definitions, '\n');
  await out.flush();
  await out.close();
  await Process.run('dart', ['fix', '--apply', targetFile.path]);
  await Process.run('dart', ['format', targetFile.path]);
}
