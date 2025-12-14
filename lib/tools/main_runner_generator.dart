import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'annotations.dart';

class A extends GeneratorForAnnotation {}

class MainRunnerGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    const typeChecker = TypeChecker.typeNamed(Problem);

    final annotatedElements = library.annotatedWith(
      typeChecker,
      throwOnUnresolved: true,
    );
    if (annotatedElements.isEmpty) return '';

    final buffer = StringBuffer();

    buffer.writeln('void main() {');

    for (var annotatedElement in annotatedElements) {
      final element = annotatedElement.element;
      final annotation = annotatedElement.annotation;
      final label = annotation.read('label').stringValue;

      buffer.writeln('// $element');
      buffer.writeln('// $annotation');
      buffer.writeln('  print("${label}"); ');
      buffer.writeln();
    }

    buffer.writeln('}');

    return buffer.toString();
  }

  // @override
  // String generate(LibraryReader library, BuildStep buildStep) {
  //   final buffer = StringBuffer();

  //   // Find all functions annotated with @AoC
  //   final annotation = TypeChecker.fromStatic(Problem);
  //   final annotatedElements = library.annotatedWith(annotation);

  //   if (annotatedElements.isEmpty) return '';

  //   buffer.writeln('void main() {');
  //   for (var element in annotatedElements) {
  //     final annotation = element.annotation;
  //     final day = annotation.peek('day')?.intValue;
  //     final part = annotation.peek('part')?.intValue;

  //     // Generate code that calls the annotated function
  //     buffer.writeln('  print("Running Day $day Part $part...");');
  //     buffer.writeln('  ${element.element.name}();');
  //   }
  //   buffer.writeln('}');

  //   return buffer.toString();
  // }
}

Builder mainRunnerBuilder(BuilderOptions options) =>
    LibraryBuilder(MainRunnerGenerator(), generatedExtension: '.main.dart');
