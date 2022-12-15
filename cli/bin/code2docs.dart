import 'dart:io';

import 'package:args/args.dart';
import 'package:code2docs/code2docs.dart';
import 'package:path/path.dart' as path;
import 'package:code2docs_cli/code2docs_cli.dart' as code2docs_cli;

void main(List<String> arguments) {
  var parser = ArgParser();

  parser.addOption('output', abbr: 'o', mandatory: true);
  parser.addOption('language', abbr: 'l', defaultsTo: 'dart');

  final result = parser.parse(arguments);

  if (result.rest.isEmpty) {
    // TODO: display output
    stdout.writeln('Invalid command');
    exitCode = 1;
    return;
  }

  final input = result.rest.first;
  final output = result['output'];
  final language = result['language'];

  stdout.writeln('Generating files from $input to $output');

  final inputDir = Directory(input);
  final outputDir = Directory(path.absolute(output));

  if (!inputDir.existsSync()) {
    stdout.writeln('Directory $input does not exist');
    exitCode = 1;
    return;
  }

  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  final fileList = inputDir.listSync();
  for (final fileEntity in fileList) {
    final file = File(fileEntity.absolute.path);
    final fileContents = file.readAsStringSync();

    final generator = SourceCodeSampleToMarkdown(language: language);
    final markdown = generator.generate(fileContents);

    final outputPath = path.join(outputDir.path, '${path.basename(fileEntity.path)}.md');
    final outputFile = File(outputPath);

    outputFile.writeAsStringSync(markdown);
  }
}
